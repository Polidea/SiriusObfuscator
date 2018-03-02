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
  } else if (Declaration->isImplicit()) {
    return stringError("The variable is implicit. It must not be renamed.");
  }
  return llvm::Error::success();
}
  
SingleSymbolOrError
parseOverridenDeclaration(const VarDecl *Declaration,
                          const std::string &ModuleName) {
  auto BaseWithModules = getBaseOverridenDeclarationWithModules(Declaration);
  auto Base = BaseWithModules.first;
  auto Modules = BaseWithModules.second;

  if (isOverriddenMethodFromTheSameModule(Modules, ModuleName)) {
    return parse(Base);
  } else {
    return stringError("only overriding properties from the same module "
                       "might be safely obfuscated");
  }
}

llvm::Expected<ModuleNameAndParts>
variableIdentifierPartsFromContext(const VarDecl *Declaration) {

  std::string ModuleName;
  std::vector<std::string> Parts;
  
  auto ProtocolRequirements = Declaration->getSatisfiedProtocolRequirements();
  auto *ProtocolDeclaration =
    dyn_cast<ProtocolDecl>(Declaration->getDeclContext());

  // TODO: for now, we're renaming properties from different protocols
  // but with the same name to the same obfuscated name.
  // This should be improved in the future.
  if (!ProtocolRequirements.empty() || ProtocolDeclaration != nullptr) {

    // TODO: If the property satisfies multiple protocols, we're using
    // the module name from the first of the protocols. This may lead to errors
    // and should be changed in the future.
    ModuleName = ProtocolRequirements.empty()
                    ? moduleName(ProtocolDeclaration)
                    : moduleName(ProtocolRequirements.front());
    Parts.push_back("module." + ModuleName);
    Parts.push_back("protocol");

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

  if (ModuleName.empty() && Parts.empty()) {
    return stringError("No supported variable declaration found");
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
  
  auto ModuleAndPartsOrError = variableIdentifierPartsFromContext(Declaration);
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
