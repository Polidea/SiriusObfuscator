#include "swift/Obfuscation/ExtensionExcluder.h"
#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"

namespace swift {
namespace obfuscation {

void
ExtensionExcluder::
identifyExclusions(Decl *Declaration) {

  if(auto ExtensionDeclaration = dyn_cast<ExtensionDecl>(Declaration)) {
    
    std::vector<SymbolWithRange> Results;
    auto *ExtendedType = ExtensionDeclaration->getExtendedType()->getAnyNominal();
    auto ExtensionModuleName = moduleName(ExtensionDeclaration);
    if (ExtendedType == nullptr) {
      return;
    }

    auto ExtendedTypeModuleName = moduleName(ExtendedType);
    if (ExtensionModuleName == ExtendedTypeModuleName) {
      return;
    }

    if (!ExtensionDeclaration->getMembers().empty()) {
      return;
    }

    auto InheritedArray = ExtensionDeclaration->getInherited();

    for (auto Inherited : InheritedArray) {

      auto *Nominal = Inherited.getType()->getAnyNominal();
      if (auto *ProtocolDeclaration = dyn_cast_or_null<ProtocolDecl>(Nominal)) {
        for (auto *Member : ProtocolDeclaration->getMembers()) {
          Member->getSourceRange();
          for (auto *Declaration : ExtendedType->getMembers()) {

            if (auto *ExtFunction = dyn_cast<AbstractFunctionDecl>(Declaration)) {
              if (auto *ProtocolFunction =
                    dyn_cast<AbstractFunctionDecl>(Member)) {

                auto ExtFunctionSignature = functionSignature(ExtFunction);
                auto ProtocolFunctionSignature =
                  functionSignature(ProtocolFunction);
                auto ExtFunctionName = ExtFunction->getName().str().str();
                auto ProtocolFunctionName =
                  ProtocolFunction->getName().str().str();

                if (ExtFunctionSignature == ProtocolFunctionSignature
                    && ExtFunctionName == ProtocolFunctionName) {
                  DeclarationsToExclude.insert(Member);
                }
              }
            }

            if (auto *ExtFunction = dyn_cast<AbstractStorageDecl>(Declaration)) {
              if (auto *ProtocolFunction =
                    dyn_cast<AbstractStorageDecl>(Member)) {

                auto ExtFunctionSignature =
                  ExtFunction->getInterfaceType().getString();
                auto ProtocolFunctionSignature =
                  ProtocolFunction->getInterfaceType().getString();
                auto ExtFunctionName = ExtFunction->getName().str().str();
                auto ProtocolFunctionName =
                  ProtocolFunction->getName().str().str();

                if (ExtFunctionSignature == ProtocolFunctionSignature
                    && ExtFunctionName == ProtocolFunctionName) {
                  DeclarationsToExclude.insert(Member);
                }
              }
            }
          }
        }
      }
    }
  }
}

} //namespace obfuscation
} //namespace swift
