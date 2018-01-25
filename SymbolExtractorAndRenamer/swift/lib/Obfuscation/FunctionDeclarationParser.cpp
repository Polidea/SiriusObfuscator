#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

std::string functionName(const FuncDecl* Declaration) {
  return Declaration->getName().str().str();
}

llvm::Error isDeclarationSupported(const FuncDecl* Declaration) {
  if (Declaration->isBinaryOperator() || Declaration->isUnaryOperator()) {
    return stringError("don't support operators right now, since it requires "
                       "the special obfuscated identifier");
  }
  if (Declaration->isGetterOrSetter()) {
    return stringError("don't support getters and setters right now, since "
                       "it's the computed property name that should be "
                       "obfuscated");
  }
  if (Declaration->isAccessor() || Declaration->isObservingAccessor()) {
    return stringError("don't support property accessors right now");
  }
  return llvm::Error::success();
}

const FuncDecl*
baseOverridenDeclarationWithModules(const FuncDecl* Declaration,
                                    std::set<std::string> &Modules) {
  if (auto* OverrideDeclaration = Declaration->getOverriddenDecl()) {
    Modules.insert(moduleName(OverrideDeclaration));
    return baseOverridenDeclarationWithModules(OverrideDeclaration, Modules);
  } else {
    return Declaration;
  }
}

std::string functionSignature(const FuncDecl *Declaration) {
  if (Declaration->getDeclContext()->isTypeContext()) {
    auto Interface = Declaration->getMethodInterfaceType().getString();
    return "signature." + Interface;
  } else {
    return "signature." + Declaration->getInterfaceType().getString();
  }
}

ModuleNameAndParts functionIdentifierParts(const FuncDecl *Declaration,
                                           const std::string &ModuleName,
                                           const std::string &SymbolName) {
  std::vector<std::string> Parts;
  std::string UpdatedModuleName = ModuleName;
  auto ProtocolRequirements = Declaration->getSatisfiedProtocolRequirements();
  auto *ProtocolDeclaration =
  dyn_cast<ProtocolDecl>(Declaration->getDeclContext());
  if (ProtocolRequirements.empty() && ProtocolDeclaration == nullptr) {
    
    auto TypeNameOrError = enclosingTypeName(Declaration);
    if (auto Error = TypeNameOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      Parts.push_back("function." + SymbolName);
    } else {
      Parts.push_back("type." + TypeNameOrError.get());
      Parts.push_back("method." + SymbolName);
    }
    
  } else {
    
    // TODO: right now we're renaming all the methods in the protocols with
    //       the same name and signature to the same obfuscated name. the reason
    //       is that it greatly simplifies the handling of situation in which
    //       a protocol A has method a() and protocol B: A has method a().
    //       then the class C: B with the implementation of a() satisfies
    //       two requirements at the same time (from A and from B). however,
    //       there is no override relationship between the A.a() and B.a() in
    //       protocols. it's just a name that's the same.
    //       this simplified handling should be improved in the future.
    if (!ProtocolRequirements.empty()) {
      UpdatedModuleName = moduleName(ProtocolRequirements.front());
    } else {
      UpdatedModuleName = moduleName(ProtocolDeclaration);
    }
    Parts.push_back("protocol");
    Parts.push_back("method." + SymbolName);
  }
  
  Parts.push_back(functionSignature(Declaration));
  
  return std::make_pair(UpdatedModuleName, Parts);
}

SymbolsOrError parseOverridenDeclaration(const FuncDecl *Declaration,
                                         const std::string &ModuleName,
                                         const CharSourceRange &Range) {
  std::set<std::string> Modules;
  auto Base = baseOverridenDeclarationWithModules(Declaration, Modules);
  if (Modules.size() == 1 && Modules.count(ModuleName) == 1) {
    return parse(Base, Range);
  } else {
    return stringError("only method overriding methods from the same module "
                       "might be safely obfuscated");
  }
}
  
SymbolsOrError parse(const FuncDecl* Declaration, CharSourceRange Range) {
  
  if (auto Error = isDeclarationSupported(Declaration)) {
    return std::move(Error);
  }
  
  std::vector<SymbolWithRange> Symbols;
  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> Parts = ModuleNameAndParts.second;
  
  if (Declaration->getOverriddenDecl() != nullptr) {
    return parseOverridenDeclaration(Declaration, ModuleName, Range);
  }
  
  std::string SymbolName = functionName(Declaration);
  
  auto IdentifierParts = functionIdentifierParts(Declaration,
                                                 ModuleName,
                                                 SymbolName);
  ModuleName = IdentifierParts.first;
  copyToVector(IdentifierParts.second, Parts);
  
  Symbol Symbol(combineIdentifier(Parts),
                SymbolName,
                ModuleName,
                SymbolType::NamedFunction);
  Symbols.push_back(SymbolWithRange(Symbol, Range));
  
  auto ParametersSymbolsOrError =
    parseSeparateFunctionDeclarationForParameters(Declaration);
  if (auto Error = ParametersSymbolsOrError.takeError()) {
    return std::move(Error);
  }
  
  copyToVector(ParametersSymbolsOrError.get(), Symbols);
  
  return Symbols;
}

} //namespace obfuscation
} //namespace swift
