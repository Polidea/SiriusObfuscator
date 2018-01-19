#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

#include <sstream>
#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

std::string combineIdentifier(std::vector<std::string> &Parts) {
  if (Parts.empty()) {
    return "";
  } else if (Parts.size() == 1) {
    return Parts[0];
  } else {
    //TODO: can we rewrite it to use llvm:raw_string_ostream?
    std::stringstream ResultStream;
    std::copy(Parts.cbegin(),
              Parts.cend(),
              std::ostream_iterator<std::string>(ResultStream, "."));
    std::string Result = ResultStream.str();
    Result.pop_back();
    return Result;
  }
}
  
std::string moduleName(const Decl* Declaration) {
  return Declaration->getModuleContext()->getBaseName().getIdentifier().get();
}

std::pair<std::string, std::vector<std::string>>
moduleNameAndParts(const Decl *Declaration) {
  std::vector<std::string> Parts;
  std::string ModuleName = moduleName(Declaration);
  Parts.push_back("module");
  Parts.push_back(ModuleName);
  return std::make_pair(ModuleName, Parts);
}
  
std::string typeName(const NominalTypeDecl* Declaration) {
  return Declaration->getDeclaredInterfaceType()->getString();
}
  
llvm::Expected<std::string>
enclosingTypeName(const Decl* Declaration) {
  auto *DeclarationContext = Declaration->getDeclContext();
  if (auto *TypeDeclaration =
        DeclarationContext->getAsNominalTypeOrNominalTypeExtensionContext()) {
    return typeName(TypeDeclaration);
  }
  return stringError("enclosing context of this declaration is not supported");
}
  
llvm::Expected<Symbol> parse(const NominalTypeDecl* Declaration) {
  
  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::vector<std::string> Parts = ModuleNameAndParts.second;
  std::string SymbolName = typeName(Declaration);
  
  if (auto *EnumDeclaration = dyn_cast<EnumDecl>(Declaration)) {
    Parts.push_back("enum." + SymbolName);
  } else if (auto *ClassDeclaration = dyn_cast<ClassDecl>(Declaration)) {
    Parts.push_back("class." + SymbolName);
  } else if (auto *ProtocolDeclaration = dyn_cast<ProtocolDecl>(Declaration)) {
    Parts.push_back("protocol." + SymbolName);
  } else if (auto *StructDeclaration = dyn_cast<StructDecl>(Declaration)) {
    Parts.push_back("struct." + SymbolName);
  } else {
    return stringError("found unsupported declaration type");
  }
  
  return Symbol(combineIdentifier(Parts), SymbolName, ModuleNameAndParts.first);
}
  
std::string functionName(const FuncDecl* Declaration) {
  return Declaration->getName().str().str();
}
  
llvm::Error isDeclarationSupported(const FuncDecl* Declaration) {
  if (Declaration->getOverriddenDecl() != nullptr) {
    return stringError("don't support overriding methods right now, since it "
                       "requires information over what module the overriding "
                       "method is from");
  }
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
  
llvm::Expected<Symbol> parse(const FuncDecl* Declaration) {
  if (auto Error = isDeclarationSupported(Declaration)) {
    return std::move(Error);
  }
  
  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> Parts = ModuleNameAndParts.second;
  std::string SymbolName = functionName(Declaration);
  
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
      ModuleName = moduleName(ProtocolRequirements.front());
    } else {
      ModuleName = moduleName(ProtocolDeclaration);
    }
    Parts.push_back("protocol");
    Parts.push_back("method." + SymbolName);
    
  }
  
  if (Declaration->getDeclContext()->isTypeContext()) {
    auto Interface = Declaration->getMethodInterfaceType().getString();
    Parts.push_back("signature." + Interface);
  } else {
    Parts.push_back("signature." + Declaration->getInterfaceType().getString());
  }
  
  return Symbol(combineIdentifier(Parts), SymbolName, ModuleName);
}

llvm::Expected<Symbol> parse(const ValueDecl* Declaration) {
  return stringError("found unsupported declaration type");
}

llvm::Expected<Symbol> extractSymbol(Decl* Declaration) {
  std::unique_ptr<llvm::Expected<Symbol>> SymbolOrError(nullptr);
  if (const auto *NominalTypeDeclaration =
        dyn_cast<NominalTypeDecl>(Declaration)) {
    SymbolOrError =
      llvm::make_unique<llvm::Expected<Symbol>>(parse(NominalTypeDeclaration));
  } else if (const auto *FuncDeclaration = dyn_cast<FuncDecl>(Declaration)) {
    SymbolOrError =
      llvm::make_unique<llvm::Expected<Symbol>>(parse(FuncDeclaration));
  } else if (const auto *ValueDeclaration = dyn_cast<ValueDecl>(Declaration)) {
    SymbolOrError =
      llvm::make_unique<llvm::Expected<Symbol>>(parse(ValueDeclaration));
  } else {
    return stringError("unsupported declaration type");
  }
  
  if (auto Error = SymbolOrError->takeError()) {
    return std::move(Error);
  }
  return SymbolOrError->get();
}
  
} //namespace obfuscation
} //namespace swift
