#include "swift/Obfuscation/ConfigurationExcluder.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

namespace swift {
namespace obfuscation {

ConfigurationExcluder::
  ConfigurationExcluder(ObfuscationConfiguration&& Configuration)
: Configuration(std::move(Configuration)) {}

void
ConfigurationExcluder::
  excludeIfNeeded(Decl *Declaration,
                  const std::pair<const ClassDecl *, std::string> &DeclarationAndModule,
                  const InheritanceExclusion *ExcludedType) {
  auto TypeName = typeName(DeclarationAndModule.first);
  auto ModuleName = DeclarationAndModule.second;
  if (ExcludedType->Base == TypeName
      && ExcludedType->Module == ModuleName) {
    DeclarationsToExclude.insert(Declaration);
  }
}

void ConfigurationExcluder::
  handleTypeExclusion(const TypeExclusion *Exclusion, Decl *Declaration) {
    NominalTypeDecl* NominalTypeDeclaration = nullptr;
    if (auto *NominalType = dyn_cast<NominalTypeDecl>(Declaration)) {
      NominalTypeDeclaration = NominalType;
    } else if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
      NominalTypeDeclaration = Extension->getExtendedType()->getAnyNominal();
    }
    if (Exclusion != nullptr && NominalTypeDeclaration != nullptr) {
      auto TypeName = typeName(NominalTypeDeclaration);
      auto ModuleName = moduleName(NominalTypeDeclaration);
      if (Exclusion->Name == TypeName
          && Exclusion->Module == ModuleName) {
        DeclarationsToExclude.insert(Declaration);
      }
    }
  }

void ConfigurationExcluder::
handleInheritanceExclusion(const InheritanceExclusion *Exclusion, Decl *Declaration) {

  ClassDecl* ClassDeclaration = nullptr;
  if (auto *ClassType = dyn_cast<ClassDecl>(Declaration)) {
    ClassDeclaration = ClassType;
  } else if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
    ClassDeclaration =
    Extension->getExtendedType()->getClassOrBoundGenericClass();
  }

  if (Exclusion != nullptr && ClassDeclaration != nullptr) {
    auto DeclarationsWithModules =
    getSuperClassDeclarationsWithModules(ClassDeclaration);
    if (!DeclarationsWithModules.empty()) {
      if (Exclusion->Transitive) {
        for (auto DeclarationAndModule : DeclarationsWithModules) {
          excludeIfNeeded(Declaration, DeclarationAndModule, Exclusion);
        }
      } else {
        excludeIfNeeded(Declaration,
                        DeclarationsWithModules.front(),
                        Exclusion);
      }
    }
  }
}

void ConfigurationExcluder::
handleConformanceExclusion(const ConformanceExclusion *Exclusion,
                           Decl *Declaration) {

    NominalTypeDecl* NominalTypeDeclaration = nullptr;
    if (auto *NominalType = dyn_cast<NominalTypeDecl>(Declaration)) {
      NominalTypeDeclaration = NominalType;
    } else if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
      NominalTypeDeclaration = Extension->getExtendedType()->getAnyNominal();
    }

    if (Exclusion != nullptr && NominalTypeDeclaration != nullptr) {
      if (Exclusion->Transitive) {
        std::vector<const NominalTypeDecl *>
          DeclarationsToIdentifyProtocolsConformance;
        DeclarationsToIdentifyProtocolsConformance
          .push_back(NominalTypeDeclaration);
        if (auto *ClassDeclaration =
            dyn_cast<ClassDecl>(NominalTypeDeclaration)) {
          auto DeclarationsWithModules =
          getSuperClassDeclarationsWithModules(ClassDeclaration);
          for (auto DeclarationAndModule : DeclarationsWithModules) {
            DeclarationsToIdentifyProtocolsConformance
            .push_back(DeclarationAndModule.first);
          }
        }
        for (auto DeclarationToIdentify
             : DeclarationsToIdentifyProtocolsConformance) {
          auto ProtocolsWithModules =
          getConformingProtocolDeclarationsWithModules(DeclarationToIdentify);
          for (auto ProtocolAndModule : ProtocolsWithModules) {
            auto TypeName = typeName(ProtocolAndModule.first);
            auto ModuleName = ProtocolAndModule.second;
            if (Exclusion->Protocol == TypeName
                && Exclusion->Module == ModuleName) {
              DeclarationsToExclude.insert(Declaration);
            }
          }
        }
      } else {
        auto InheritedArray = NominalTypeDeclaration->getInherited();
        for (auto Inherited : InheritedArray) {
          auto Nominal = Inherited.getType()->getAnyNominal();
          if (auto *Protocol = dyn_cast_or_null<ProtocolDecl>(Nominal)) {
            auto TypeName = typeName(Protocol);
            auto ModuleName = moduleName(Protocol);
            if (Exclusion->Protocol == TypeName
                && Exclusion->Module == ModuleName) {
              DeclarationsToExclude.insert(Declaration);
            }
          }
        }
      }
    }
  }

void ConfigurationExcluder::identifyExclusions(Decl *Declaration) {

  for (auto &Exclusion : this->Configuration.Exclude) {
    switch (Exclusion->Kind) {
      case ExclusionKind::UnknownKind:
        break;
      case ExclusionKind::Type: {
        handleTypeExclusion(Exclusion->getAsTypeExclusion(), Declaration);
        break;
      }
      case ExclusionKind::Inheritance: {
        handleInheritanceExclusion(Exclusion->getAsInheritanceExclusion(),
                                   Declaration);
        break;
      }
      case ExclusionKind::Conformance: {
        handleConformanceExclusion(Exclusion->getAsConformanceExclusion(),
                                   Declaration);
        break;
      }
    }
  }

}

} // namespace obfuscation
} // namespace swift
