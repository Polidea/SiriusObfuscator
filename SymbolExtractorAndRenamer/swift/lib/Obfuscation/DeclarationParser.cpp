#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {
  
using SingleSymbolOrError = llvm::Expected<Symbol>;
  
SingleSymbolOrError parse(const NominalTypeDecl* Declaration) {
  
  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
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
  
  return Symbol(combineIdentifier(Parts),
                SymbolName,
                ModuleName,
                SymbolType::Type);
}

SingleSymbolOrError parse(const VarDecl* Declaration) {
  
  if (Declaration->getOverriddenDecl() != nullptr) {
    return stringError("obfuscating overriding properties is not supported");
  }
  
  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> Parts = ModuleNameAndParts.second;
  std::string SymbolName = Declaration->getName().str().str();
  
  if (auto *FunctionDeclaration =
      dyn_cast<FuncDecl>(Declaration->getDeclContext())) {
    std::string FunctionName = functionName(FunctionDeclaration);
    auto ModuleAndParts = functionIdentifierParts(FunctionDeclaration,
                                                  ModuleName,
                                                  FunctionName);
    copyToVector(ModuleAndParts.second, Parts);
  }
  
  Parts.push_back("variable." + SymbolName);
  
  return Symbol(combineIdentifier(Parts),
                SymbolName,
                ModuleName,
                SymbolType::Variable);
}

SymbolsOrError extractSymbol(Decl* Declaration, CharSourceRange Range) {
  
  std::unique_ptr<SingleSymbolOrError> SingleSymbolOrErrorPointer(nullptr);
  std::unique_ptr<SymbolsOrError> SymbolsOrErrorPointer(nullptr);
  
  if (const auto *NominalTypeDeclaration =
        dyn_cast<NominalTypeDecl>(Declaration)) {
    SingleSymbolOrErrorPointer =
      llvm::make_unique<SingleSymbolOrError>(parse(NominalTypeDeclaration));
  } else if (const auto *FuncDeclaration = dyn_cast<FuncDecl>(Declaration)) {
    SymbolsOrErrorPointer =
      llvm::make_unique<SymbolsOrError>(parse(FuncDeclaration, Range));
  } else if (const auto *ParamDeclaration = dyn_cast<ParamDecl>(Declaration)) {
    auto Symbols = parseSeparateDeclarationWithRange(ParamDeclaration, Range);
    SymbolsOrErrorPointer =
      llvm::make_unique<SymbolsOrError>(std::move(Symbols));
  } else if (const auto *VariableDeclaration = dyn_cast<VarDecl>(Declaration)) {
    SingleSymbolOrErrorPointer =
      llvm::make_unique<SingleSymbolOrError>(parse(VariableDeclaration));
  } else {
    return stringError("unsupported declaration type");
  }
  
  if (SingleSymbolOrErrorPointer) {
    if (auto Error = SingleSymbolOrErrorPointer->takeError()) {
      return std::move(Error);
    }
    SymbolWithRange Symbol(SingleSymbolOrErrorPointer->get(), Range);
    return std::vector<SymbolWithRange> { Symbol };
  } else if (SymbolsOrErrorPointer) {
    if (auto Error = SymbolsOrErrorPointer->takeError()) {
      return std::move(Error);
    }
    return SymbolsOrErrorPointer->get();
  } else {
    return stringError("unsupported declaration type");
  }
}
  
} //namespace obfuscation
} //namespace swift
