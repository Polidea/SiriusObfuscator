#include "swift/Obfuscation/Includer.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

Includer::~Includer() = default;

DeclsWithRangesOrErrors
NominalTypeIncluder::include(DeclWithRange &DeclAndRange) {
  if (dyn_cast_or_null<NominalTypeDecl>(DeclAndRange.Declaration)
      && DeclAndRange.Range.isValid()) {
      return wrapInVector(DeclAndRange);
  }
  return wrapInVector<DeclWithRange>(stringError("NominalTypeIncluder doesn't support this "
                                  "DeclWithRange"));
}

DeclsWithRangesOrErrors
FunctionNameIncluder::include(DeclWithRange &DeclAndRange) {
  if (auto Function = dyn_cast_or_null<FuncDecl>(DeclAndRange.Declaration)) {
    if (DeclAndRange.Range.isValid()
        && !Function->isOperator()
        && !Function->isGetter()
        && (Function->isSetter()
            || (!Function->isAccessor() && !Function->isObservingAccessor()))) {
      return wrapInVector(DeclAndRange);
    }
  }

  return wrapInVector<DeclWithRange>(stringError("FunctionNameIncluder doesn't support this "
                                  "DeclWithRange"));
}

OperatorIncluder::OperatorIncluder(OperatorExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithRangesOrErrors
OperatorIncluder::include(DeclWithRange &DeclAndRange) {

  if (auto Function = dyn_cast_or_null<FuncDecl>(DeclAndRange.Declaration)) {
    if (DeclAndRange.Range.isValid() && Function->isOperator()) {
      if (auto OperatorDecl = Function->getOperatorDecl()) {
        auto OperatorModuleName = Extractor.moduleName(OperatorDecl);
        if (Extractor.moduleName(Function) != OperatorModuleName) {
          return wrapInVector<DeclWithRange>(stringError("We don't rename the operator if "
                                          "the operator is from other module "
                                          "than the operator's implementation"));
        }
      }
      return wrapInVector(DeclAndRange);
    }
  } else if (auto Operator =
              dyn_cast_or_null<OperatorDecl>(DeclAndRange.Declaration)) {
    return wrapInVector(DeclAndRange);
  }
  return wrapInVector<DeclWithRange>(stringError("OperatorIncluder doesn't support this "
                                  "DeclWithRange"));
}

FunctionParametersIncluder::
  FunctionParametersIncluder(ParameterExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithRangesOrErrors
FunctionParametersIncluder::include(DeclWithRange &DeclAndRange) {
  if (auto Parameter = dyn_cast_or_null<ParamDecl>(DeclAndRange.Declaration)) {

    if (DeclAndRange.Range.isValid() && Parameter->getNameLoc().isValid()) {

      auto InternalName = Extractor.internalParameterName(Parameter);

      CharSourceRange ComputedRange(Parameter->getNameLoc(),
                                    InternalName.length());

      if (!ComputedRange.overlaps(DeclAndRange.Range)
          && Parameter->isImplicit()) {
        return wrapInVector<DeclWithRange>(stringError("We must not rename the implicit "
                                        "parameters at the usage place."));
      }
      return wrapInVector(DeclAndRange);
    }

  }
  if (auto Constructor =
        dyn_cast_or_null<ConstructorDecl>(DeclAndRange.Declaration)) {
    if (Constructor->isImplicit()) {
      return wrapInVector<DeclWithRange>(stringError("We dont want to parse the implicit "
                                      "constructor declarations, only their "
                                      "usage via calls."));
    }
  }
  if (auto Function =
        dyn_cast_or_null<AbstractFunctionDecl>(DeclAndRange.Declaration)) {

    DeclsWithRangesOrErrors Declarations;

    auto DeclsWithRanges = Extractor.parametersFrom(Function);

    for (auto DeclAndRange : DeclsWithRanges) {
      if (auto *Parameter = dyn_cast_or_null<ParamDecl>(DeclAndRange.Declaration)) {
        if (!Parameter->isImplicit()) {
          Declarations.push_back(DeclAndRange);
        }
      }
    }

    return Declarations;
  }
  return wrapInVector<DeclWithRange>(stringError("OperatorIncluder doesn't support this "
                                  "DeclWithRange"));
}

VariableIncluder::VariableIncluder(VariableExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithRangesOrErrors VariableIncluder::include(DeclWithRange &DeclAndRange) {
  auto *Declaration = DeclAndRange.Declaration;

  if (auto *Parameter = dyn_cast_or_null<ParamDecl>(Declaration)) {

    if (const auto *Constructor =
          dyn_cast_or_null<ConstructorDecl>(Parameter->getDeclContext())) {
      if (!Constructor->isImplicit()) {
        return wrapInVector<DeclWithRange>(stringError("The supposedly memberwise constructor "
                                                       "is not memberwise, because it isn't implicit."));
      }
      auto *StructDeclaration =
        Constructor->getResultInterfaceType()->getStructOrBoundGenericStruct();
      if (StructDeclaration == nullptr) {
        return wrapInVector<DeclWithRange>(stringError("The supposedly memberwise constructor "
                                        "is not memberwise, because it doesn't "
                                        "come from struct"));
      }
      auto Properties = StructDeclaration->getStoredProperties();
      for (auto Variable : Properties) {
        if (Extractor.declarationName(Variable)
            == Extractor.declarationName(Parameter)) {
          return wrapInVector(DeclWithRange(Variable, DeclAndRange.Range));
        }
      }
      return wrapInVector<DeclWithRange>(stringError("Failed to find struct property with "
                                      "the same name as memberwise constructor "
                                      "parameter"));
    } else {
      return wrapInVector<DeclWithRange>(stringError("Failed to parse constructor declaration"
                                      "from parameter"));
    }
  } else if (auto *Variable = dyn_cast_or_null<VarDecl>(Declaration)) {

      if (Variable->isCaptureList()) {
        return wrapInVector<DeclWithRange>(stringError("The variable is the element of "
                                        "closure's capture list. It must not "
                                        "be renamed."));
      } else if (Variable->isImplicit()) {
        return wrapInVector<DeclWithRange>(stringError("Only explicit variables might be "
                                        "safely obfuscated"));
      } else if (Variable->getOverriddenDecl() != nullptr) {
        auto BaseWithModules = Extractor.getBaseOverridenDeclarationWithModules(Variable);
        auto Base = const_cast<VarDecl *>(BaseWithModules.first);
        auto Modules = BaseWithModules.second;

        if (Extractor.isOverriddenMethodFromTheSameModule(Modules,
                                                          Extractor.moduleName(Variable))) {
          return wrapInVector(DeclWithRange(Base, DeclAndRange.Range));
        } else {
          return wrapInVector<DeclWithRange>(stringError("only overriding properties from the same "
                                          "module might be safely obfuscated"));
        }
      } else {
        return wrapInVector(DeclAndRange);
      }
  }

  return wrapInVector<DeclWithRange>(stringError("VariableIncluder doesn't support "
                                  "this DeclWithRange"));

}

} //namespace obfuscation
} //namespace swift

