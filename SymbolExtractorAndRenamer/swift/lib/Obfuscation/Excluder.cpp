#include "swift/Obfuscation/Excluder.h"

namespace swift {
namespace obfuscation {

ConfigurationExcluder::
ConfigurationExcluder(ObfuscationConfiguration && Configuration,
                      class NominalTypeExtractor &Extractor)
: Configuration(std::move(Configuration)),
  NominalTypeExtractor(Extractor) {}

bool
ConfigurationExcluder::
shouldExclude(Decl *Declaration,
              const std::pair<const ClassDecl *,
              std::string> &DeclarationAndModule,
              const InheritanceExclusion *ExcludedType) {
  auto TypeName = NominalTypeExtractor.typeName(DeclarationAndModule.first);
  auto ModuleName = DeclarationAndModule.second;
  if (ExcludedType->Base == TypeName
      && ExcludedType->Module == ModuleName) {
    return true;
  }
  return false;
}

bool ConfigurationExcluder::
handleTypeExclusion(const TypeExclusion *Exclusion, Decl *Declaration) {
  NominalTypeDecl* NominalTypeDeclaration = nullptr;
  if (auto *NominalType = dyn_cast<NominalTypeDecl>(Declaration)) {
    NominalTypeDeclaration = NominalType;
  } else if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
    NominalTypeDeclaration = Extension->getExtendedType()->getAnyNominal();
  }
  if (Exclusion != nullptr && NominalTypeDeclaration != nullptr) {
    auto TypeName = NominalTypeExtractor.typeName(NominalTypeDeclaration);
    auto ModuleName = NominalTypeExtractor.moduleName(NominalTypeDeclaration);
    if (Exclusion->Name == TypeName
        && Exclusion->Module == ModuleName) {
      return true;
    }
  }
  return false;
}

bool ConfigurationExcluder::
handleInheritanceExclusion(const InheritanceExclusion *Exclusion,
                           Decl *Declaration) {

  ClassDecl* ClassDeclaration = nullptr;
  if (auto *ClassType = dyn_cast<ClassDecl>(Declaration)) {
    ClassDeclaration = ClassType;
  } else if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
    ClassDeclaration =
    Extension->getExtendedType()->getClassOrBoundGenericClass();
  }

  if (Exclusion != nullptr && ClassDeclaration != nullptr) {
    auto DeclarationsWithModules = NominalTypeExtractor
    .getSuperClassDeclarationsWithModules(ClassDeclaration);
    if (!DeclarationsWithModules.empty()) {
      if (Exclusion->Transitive) {
        for (auto DeclarationAndModule : DeclarationsWithModules) {
          if (shouldExclude(Declaration, DeclarationAndModule, Exclusion)) {
            return true;
          }
        }
        return false;
      } else {
        return shouldExclude(Declaration,
                             DeclarationsWithModules.front(),
                             Exclusion);
      }
    }
  }
  return false;
}

bool ConfigurationExcluder::
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
        auto DeclarationsWithModules = NominalTypeExtractor
        .getSuperClassDeclarationsWithModules(ClassDeclaration);
        for (auto DeclarationAndModule : DeclarationsWithModules) {
          DeclarationsToIdentifyProtocolsConformance
          .push_back(DeclarationAndModule.first);
        }
      }
      for (auto DeclarationToIdentify
           : DeclarationsToIdentifyProtocolsConformance) {
        auto ProtocolsWithModules = NominalTypeExtractor
        .getConformingProtocolDeclarationsWithModules(DeclarationToIdentify);
        for (auto ProtocolAndModule : ProtocolsWithModules) {
          auto TypeName = NominalTypeExtractor.typeName(ProtocolAndModule.first);
          auto ModuleName = ProtocolAndModule.second;
          if (Exclusion->Protocol == TypeName
              && Exclusion->Module == ModuleName) {
            return true;
          }
        }
      }
    } else {
      auto InheritedArray = NominalTypeDeclaration->getInherited();
      for (auto Inherited : InheritedArray) {
        auto Nominal = Inherited.getType()->getAnyNominal();
        if (auto *Protocol = dyn_cast_or_null<ProtocolDecl>(Nominal)) {
          auto TypeName = NominalTypeExtractor.typeName(Protocol);
          auto ModuleName = NominalTypeExtractor.moduleName(Protocol);
          if (Exclusion->Protocol == TypeName
              && Exclusion->Module == ModuleName) {
            return true;
          }
        }
      }
    }
  }
  return false;
}

llvm::Optional<DeclWithSymbolWithRange> ConfigurationExcluder::
symbolsToExclude(DeclWithSymbolWithRange &DeclAndSymbolWithRange) {

  bool shouldExclude = false;

  for (auto &Exclusion : this->Configuration.Exclude) {
    switch (Exclusion->Kind) {
      case ExclusionKind::UnknownKind:
        break;
      case ExclusionKind::Type: {
        auto *TypeExclusion = Exclusion->getAsTypeExclusion();
        shouldExclude = handleTypeExclusion(TypeExclusion,
                                            DeclAndSymbolWithRange.Declaration);
        break;
      }
      case ExclusionKind::Inheritance: {
        auto *InheritanceExclusion = Exclusion->getAsInheritanceExclusion();
        shouldExclude = handleInheritanceExclusion(InheritanceExclusion,
                                                   DeclAndSymbolWithRange.Declaration);
        break;
      }
      case ExclusionKind::Conformance: {
        auto *ConformanceExclusion = Exclusion->getAsConformanceExclusion();
        shouldExclude = handleConformanceExclusion(ConformanceExclusion,
                                                   DeclAndSymbolWithRange.Declaration);
        break;
      }
    }
    if (shouldExclude) { return DeclAndSymbolWithRange; }
  }

  return llvm::None;
}


llvm::Optional<DeclWithSymbolWithRange>
NSManagedExcluder::
  symbolsToExclude(DeclWithSymbolWithRange &DeclAndSymbolWithRange) {

  if (auto NominalDeclaration =
        dyn_cast<NominalTypeDecl>(DeclAndSymbolWithRange.Declaration)) {

    auto ClassOrExtensionCtx
      = NominalDeclaration->getAsClassOrClassExtensionContext();

    if(ClassOrExtensionCtx != nullptr) {

      auto SuperClass =
        NominalDeclaration->getAsClassOrClassExtensionContext()->getSuperclassDecl();
      if(SuperClass != nullptr) {

        if(SuperClass->getName().str() == "NSManagedObject") {
          return DeclAndSymbolWithRange;
        }
      }
    }

  } else if (auto *VariableDeclaration =
              dyn_cast<VarDecl>(DeclAndSymbolWithRange.Declaration)) {

    if(VariableDeclaration->getAttrs().hasAttribute<NSManagedAttr>()) {
      return DeclAndSymbolWithRange;
    }
  }
  return llvm::None;
}

} //namespace obfuscation
} //namespace swift
