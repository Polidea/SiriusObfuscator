#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

llvm::Error isDeclarationSupported(const VarDecl *Declaration) {
  if (Declaration->isCaptureList()) {
    return stringError("The variable is the element of closure's "
                       "capture list. It must not be renamed.");
  }
  return llvm::Error::success();
}
  
SingleSymbolOrError
parseOverridenDeclaration(const VarDecl *Declaration,
                          const std::string &ModuleName) {
  auto BaseWithModules = getBaseOverridenDeclarationWithModules(Declaration);
  auto Base = BaseWithModules.first;
  auto Modules = BaseWithModules.second;
  if (Modules.size() == 1 && Modules.count(ModuleName) == 1) {
    return parse(Base);
  } else {
    return stringError("only overriding properties from the same module "
                       "might be safely obfuscated");
  }
}

llvm::Expected<ModuleNameAndParts>
variableContextParts(const VarDecl *Declaration) {
  std::string ModuleName;
  std::vector<std::string> Parts;
  
  auto ProtocolRequirements = Declaration->getSatisfiedProtocolRequirements();
  auto *ProtocolDeclaration =
  dyn_cast<ProtocolDecl>(Declaration->getDeclContext());
  // TODO: for now, we're renaming all protocol properties with the same name
  // to the same obfuscated name. this should be improved in the future.
  if (!ProtocolRequirements.empty() || ProtocolDeclaration != nullptr) {
    ModuleName = ProtocolRequirements.empty() ?
    moduleName(ProtocolDeclaration) : moduleName(ProtocolRequirements.front());
    Parts.push_back("module." + ModuleName);
    Parts.push_back("protocol");
    
  } else if (auto *FunctionDeclaration =
             dyn_cast<FuncDecl>(Declaration->getDeclContext())) {
    auto ModuleAndParts = functionIdentifierParts(FunctionDeclaration);
    ModuleName = moduleName(Declaration);
    Parts = ModuleAndParts.second;
    
  } else if (auto *NominalTypeDeclaration =
             dyn_cast<NominalTypeDecl>(Declaration->getDeclContext())) {
    ModuleName = moduleName(Declaration);
    Parts.push_back("module." + ModuleName);
    std::string TypeName = typeName(NominalTypeDeclaration);
    auto ModuleAndParts = nominalTypeIdentifierParts(NominalTypeDeclaration,
                                                     TypeName);
    if (auto Error = ModuleAndParts.takeError()) {
      return std::move(Error);
    }
    copyToVector(ModuleAndParts.get(), Parts);
  } else if (Declaration->getDeclContext()->isModuleScopeContext()) {
    ModuleName = moduleName(Declaration);
    Parts.push_back("module." + ModuleName);
  }
  
  return std::make_pair(ModuleName, Parts);
}

SingleSymbolOrError parse(const VarDecl* Declaration) {
  
  if (auto Error = isDeclarationSupported(Declaration)) {
    return std::move(Error);
  }
  
  if (Declaration->getOverriddenDecl() != nullptr) {
    return parseOverridenDeclaration(Declaration, moduleName(Declaration));
  }
  
  auto ModuleAndPartsOrError = variableContextParts(Declaration);
  if (auto Error = ModuleAndPartsOrError.takeError()) {
    return std::move(Error);
  }
  auto ModuleAndParts = ModuleAndPartsOrError.get();
  
  if (Declaration->isStatic()) {
    ModuleAndParts.second.push_back("static");
  }
  
  std::string SymbolName = declarationName(Declaration);
  ModuleAndParts.second.push_back("variable." + SymbolName);
  
  return Symbol(combineIdentifier(ModuleAndParts.second),
                SymbolName,
                ModuleAndParts.first,
                SymbolType::Variable);
}
  
} //namespace obfuscation
} //namespace swift
