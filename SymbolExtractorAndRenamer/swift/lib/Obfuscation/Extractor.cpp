#include "swift/Obfuscation/Extractor.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/AST/ProtocolConformance.h"

namespace swift {
namespace obfuscation {

std::string Extractor::moduleName(const Decl* Declaration) {
  return Declaration->getModuleContext()->getBaseName().getIdentifier().get();
}

bool Extractor::
  isOverriddenMethodFromTheSameModule(const std::set<std::string> &Modules,
                                      const std::string &OriginModuleName) {
  return Modules.size() == 0
  || (Modules.size() == 1 && Modules.count(OriginModuleName) == 1);
}

Extractor::~Extractor() = default;

ModuleNameAndParts
Extractor::moduleNameAndIdentifierParts(const Decl *Declaration) {
  std::string ModuleName = moduleName(Declaration);
  std::vector<std::string> Parts;
  Parts.push_back("module");
  Parts.push_back(ModuleName);
  return std::make_pair(ModuleName, Parts);
}

template<class T>
const T* Extractor::findRecursivelyBaseOverridenDeclarationWithModules
(const T *Declaration, std::set<std::string> &Modules) {
  static_assert(std::is_base_of<Decl, T>::value, "T is not a subclass of Decl");
  if (auto* OverrideDeclaration = Declaration->getOverriddenDecl()) {
    Modules.insert(moduleName(OverrideDeclaration));
    return
    findRecursivelyBaseOverridenDeclarationWithModules(OverrideDeclaration,
                                                       Modules);
  } else {
    return Declaration;
  }
}

template<class T>
std::pair<const T*, std::set<std::string>>
Extractor::getBaseOverridenDeclarationWithModules(const T *Declaration) {
  std::set<std::string> Modules;
  auto Base = findRecursivelyBaseOverridenDeclarationWithModules(Declaration,
                                                                 Modules);
  return std::make_pair(Base, Modules);
}

//  template
//  std::pair<const VarDecl*, std::set<std::string>>
//  getBaseOverridenDeclarationWithModules(const VarDecl *Declaration);

// part of parameter extractor
//template
//std::pair<const AbstractFunctionDecl*, std::set<std::string>>
//getBaseOverridenDeclarationWithModules(const AbstractFunctionDecl *Declaration);

std::string Extractor::declarationName(const ValueDecl* Declaration) {
  return Declaration->getName().str().str();
}

std::string Extractor::typeName(const NominalTypeDecl* Declaration) {
  return Declaration->getDeclaredInterfaceType()->getString();
}

llvm::Expected<std::string>
Extractor::enclosingTypeName(const Decl* Declaration) {
  auto *DeclarationContext = Declaration->getDeclContext();
  if (auto *TypeDeclaration =
      DeclarationContext->getAsNominalTypeOrNominalTypeExtensionContext()) {
    return typeName(TypeDeclaration);
  }
  return stringError("enclosing context of this declaration is not supported");
}

llvm::Expected<std::vector<std::string>> Extractor::
  nominalTypeIdentifierParts(const NominalTypeDecl *Declaration,
                             const std::string &SymbolName) {

  std::vector<std::string> Parts;
  switch (Declaration->getKind()) {
    case DeclKind::Enum:
      Parts.push_back("enum." + SymbolName);
      break;
    case DeclKind::Class:
      Parts.push_back("class." + SymbolName);
      break;
    case DeclKind::Protocol:
      Parts.push_back("protocol." + SymbolName);
      break;
    case DeclKind::Struct:
      Parts.push_back("struct." + SymbolName);
      break;
    default:
      return stringError("found unsupported declaration type");
  }
  return Parts;
}

std::string
NominalTypeExtractor::symbolName(const NominalTypeDecl *Declaration) {
  return Declaration->getBaseName().getIdentifier().str().str();
}

ClassDeclarationsWithModules NominalTypeExtractor::
findRecursivelySuperClassDeclarationsWithModules(const ClassDecl *Declaration,
                                                 ClassDeclarationsWithModules &DeclarationsWithModules) {
  if (auto* OverridenDeclaration = Declaration->getSuperclassDecl()) {
    auto DeclarationAndModule =
    std::make_pair(OverridenDeclaration, moduleName(OverridenDeclaration));
    DeclarationsWithModules.push_back(DeclarationAndModule);
    return findRecursivelySuperClassDeclarationsWithModules(OverridenDeclaration,
                                                            DeclarationsWithModules);
  }
  return DeclarationsWithModules;
}

void NominalTypeExtractor::
findRecursivelyConformingProtocolDeclarationsWithModules(const NominalTypeDecl *Declaration,
                                                         ProtocolDeclarationsWithModules &DeclarationsWithModules) {

  for (auto Inherited : Declaration->getInherited()) {
    if (auto *ProtocolDeclaration =
        dyn_cast_or_null<ProtocolDecl>(Inherited.getType()->getAnyNominal())) {
      auto DeclarationAndModule =
        std::make_pair(ProtocolDeclaration, moduleName(ProtocolDeclaration));
      auto InsertionResult = DeclarationsWithModules.insert(DeclarationAndModule);
      if (InsertionResult.second) {
        findRecursivelyConformingProtocolDeclarationsWithModules(ProtocolDeclaration,
                                                                 DeclarationsWithModules);
      }
    }
  }
}

ProtocolDeclarationsWithModules NominalTypeExtractor::
getConformingProtocolDeclarationsWithModules(const NominalTypeDecl *Declaration) {
  ProtocolDeclarationsWithModules DeclarationsWithModules;
  findRecursivelyConformingProtocolDeclarationsWithModules(Declaration,
                                                           DeclarationsWithModules);
  return DeclarationsWithModules;
}

ClassDeclarationsWithModules NominalTypeExtractor::
  getSuperClassDeclarationsWithModules(const ClassDecl *Declaration) {
  ClassDeclarationsWithModules DeclarationsWithModules;
  return
    findRecursivelySuperClassDeclarationsWithModules(Declaration,
                                                     DeclarationsWithModules);
}

// This function handles the specific case where protocol optional function
// is declared in extension of the class conforming to the protocol
// (the function is not implemented in class, only in extension).
// Both class and protocol are in different module than extension. In this case
// `ValueDecl::getSatisfiedProtocolRequirements()` does not return the correct
// protocol requirements so we need to extract them from the extended class.
std::vector<ValueDecl*>
FunctionExtractor::satisfiedProtocolOptionalRequirements(const AbstractFunctionDecl* Declaration) {
  auto Result = std::vector<ValueDecl*>();

  auto TypeContext = Declaration->getInnermostTypeContext();
  if (TypeContext != nullptr && TypeContext->getContextKind() == DeclContextKind::ExtensionDecl) {
    auto *BaseClass = TypeContext->getAsNominalTypeOrNominalTypeExtensionContext();

    for (auto Conf : BaseClass->getAllConformances()) {

      if (Conf->getKind() == ProtocolConformanceKind::Normal) {
        auto NormalConf = cast<NormalProtocolConformance>(Conf);
        NormalConf->forEachValueWitness(nullptr, [&Declaration, &Result](ValueDecl *Req,
                                                                         Witness Witness) {
          if (auto * FuncReq = dyn_cast<AbstractFunctionDecl>(Req)) {
            if (Declaration->getEffectiveFullName() == FuncReq->getEffectiveFullName()) {
              Result.push_back(FuncReq);
            }
          }

        });
      }
    }
  }
  return Result;
}

std::vector<ValueDecl*>
FunctionExtractor::satisfiedProtocolRequirements(const AbstractFunctionDecl* Declaration) {

  std::vector<ValueDecl*> Requirements;

  Requirements = Declaration->getSatisfiedProtocolRequirements();

  auto OptionalRequirements = satisfiedProtocolOptionalRequirements(Declaration);
  copyToVector(OptionalRequirements, Requirements);

  return Requirements;
}

void FunctionExtractor::extractSignaturePart(const Type &Result,
                          llvm::raw_string_ostream &StringStream,
                          std::string Fallback) {

  if (auto *ResultTuple = Result->getAs<TupleType>()) {
    auto Results = ResultTuple->getElements();
    if (Results.empty()) {
      StringStream << Fallback;
    } else {
      StringStream << "(";
      for (auto Argument = Results.begin();
           Argument != Results.end();
           ++Argument) {
        auto Name = Argument->getName().str();
        if (!Name.empty()) {
          StringStream << Name << ": ";
        }
        if (Argument->getType()->getAs<DependentMemberType>() != nullptr) {
          // It the signature uses the associated type, we're dropping
          // the information about it. We don't use it's name nor information
          // where it comes from. We do it to handle the edga case of
          // single implementation method fulfilling two functions
          // with associated types from two different protocols.
          StringStream << "AssociatedType";
        } else {
          StringStream << Argument->getType().getString();
        }
        if (Argument != Results.drop_back().end()) {
          StringStream << ", ";
        }
      }
      StringStream << ")";
    }
  } else {
    StringStream << Result.getString();
  }
}

std::string FunctionExtractor::extractSignature(const AbstractFunctionDecl *Declaration,
                             std::string Fallback) {
  if (!Declaration->hasInterfaceType()) { return Fallback; }

  if (auto *InstanceFunction =
      Declaration->getInterfaceType()->getAs<AnyFunctionType>()) {

    AnyFunctionType *FunctionToParse = InstanceFunction;

    if (auto *Function =
        InstanceFunction->getResult()->getAs<AnyFunctionType>()) {
      FunctionToParse = Function;
    }

    std::string Signature;
    llvm::raw_string_ostream StringStream(Signature);
    extractSignaturePart(FunctionToParse->getInput(), StringStream, "()");
    StringStream << " -> ";
    extractSignaturePart(FunctionToParse->getResult(), StringStream, "Void");
    return StringStream.str();

  } else {

    return Fallback;

  }
}

std::string
FunctionExtractor::functionName(const AbstractFunctionDecl *Declaration) {
  return Declaration->getName().str().str();
}

std::string FunctionExtractor::functionSignature(const AbstractFunctionDecl *Declaration) {
  // The signature is available via different getters depending on whether
  // it is a method or a free function
  std::string Fallback;

  if (!Declaration->hasInterfaceType()) { return "no_signature"; }

  if (Declaration->getDeclContext()->isTypeContext()) {
    Fallback = Declaration->getMethodInterfaceType().getString();
  } else {
    Fallback = Declaration->getInterfaceType().getString();
  }

  auto Interface = extractSignature(Declaration, Fallback);
  return "signature." + Interface;
}

ModuleNameAndParts FunctionExtractor::
  functionIdentifierParts(const AbstractFunctionDecl *Declaration) {

  std::string ModuleName;
  std::vector<std::string> Parts;

  std::string SymbolName = declarationName(Declaration);

  // Check if function is part of protocol declaration
  auto *ProtocolDeclaration =
    Declaration->getDeclContext()->getAsProtocolOrProtocolExtensionContext();
  auto IsPartOfProtocol = ProtocolDeclaration != nullptr;

  // Check if function satisfies the protocol implemented by its
  // containing class
  auto ProtocolRequirements = satisfiedProtocolRequirements(Declaration);
  auto SatisfiesProtocol = !ProtocolRequirements.empty();

  if (!(SatisfiesProtocol || IsPartOfProtocol)) {
    // This logic applies to function that has nothing to do with protocols

    auto ModuleNameAndParts = moduleNameAndIdentifierParts(Declaration);
    ModuleName = ModuleNameAndParts.first;
    Parts = ModuleNameAndParts.second;

    // Build different identifier depending whether
    // the function is a free function or method
    auto TypeNameOrError = enclosingTypeName(Declaration);
    if (auto Error = TypeNameOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      Parts.push_back("function." + SymbolName);
    } else {
      Parts.push_back("type." + TypeNameOrError.get());
      if (Declaration->isStatic()) {
        Parts.push_back("static");
      }
      Parts.push_back("method." + SymbolName);
    }

    Parts.push_back(functionSignature(Declaration));

  } else {
    // This logic applies to function that
    // is part of protocol or satisfies protocol

    // TODO: right now we're renaming all the methods in the protocols with
    //       the same name and signature to the same obfuscated name. the reason
    //       is that it greatly simplifies the handling of situation in which
    //       a protocol A has method a() and protocol B: A has method a().
    //       then the class C: B with the implementation of a() satisfies
    //       two requirements at the same time (from A and from B). however,
    //       there is no override relationship between the A.a() and B.a() in
    //       protocols. it's just a name that's the same.
    //       this simplified handling should be improved in the future.
    ValueDecl *BaseDeclaration;
    if (SatisfiesProtocol) {
      // TODO: If the function satisfies multiple protocols, we're using
      // the module name from the first of the protocols. This may lead
      // to errors and should be changed in the future.
      BaseDeclaration = ProtocolRequirements.front();
    } else {
      BaseDeclaration = ProtocolDeclaration;
    }
    auto ModuleNameAndParts = moduleNameAndIdentifierParts(BaseDeclaration);
    ModuleName = ModuleNameAndParts.first;
    Parts = ModuleNameAndParts.second;

    Parts.push_back("protocol");
    if (Declaration->isStatic()) {
      Parts.push_back("static");
    }
    Parts.push_back("method." + SymbolName);

    if (auto *ProtocolFunctionDeclaration =
        dyn_cast<AbstractFunctionDecl>(BaseDeclaration)) {
      Parts.push_back(functionSignature(ProtocolFunctionDeclaration));
    } else {
      Parts.push_back(functionSignature(Declaration));
    }
  }

  return std::make_pair(ModuleName, Parts);
}

std::pair<const FuncDecl*, std::set<std::string>>
FunctionExtractor::getBaseOverridenDeclarationWithModules(const FuncDecl *Declaration) {
  return
    Extractor::getBaseOverridenDeclarationWithModules<FuncDecl>(Declaration);
}

std::string
OperatorExtractor::operatorName(const OperatorDecl *Declaration) {
  return Declaration->getName().str().str();
}

// Determines if the ConstructorDecl represents the Struct Memberwise
// Initializer. Checks if the declaration is implicit. Also checks if
// parameters list (other than self parameter) is not empty to exclude
// Default Initializers.
bool ParameterExtractor::
  isMemberwiseConstructor(const ConstructorDecl* Declaration) {
  auto ConstructsStruct =
    Declaration->getResultInterfaceType()->getStructOrBoundGenericStruct()
    != nullptr;

  return ConstructsStruct
         && Declaration->isImplicit()
         && Declaration->getParameters()->size() != 0;
}

bool ParameterExtractor::
  isMemberwiseConstructorParameter(const ParamDecl* Declaration) {
  auto *Context = Declaration->getDeclContext();
  if (const auto *ConstructorDeclaration = dyn_cast<ConstructorDecl>(Context)) {
    return isMemberwiseConstructor(ConstructorDeclaration);
  }
  return false;
}

std::vector<DeclWithRange>
ParameterExtractor::parametersFrom(const AbstractFunctionDecl *Function) {
  std::vector<DeclWithRange> Results;
  auto ParameterLists = Function->getParameterLists();
  if (Function->getDeclContext()->isTypeContext()
      && !ParameterLists.empty()) {
    ParameterLists = ParameterLists.drop_front();
  }
  for (auto *ParameterList : ParameterLists) {
    for (auto *Parameter : *ParameterList) {
      if (Parameter->getNameLoc().isValid()) {
        CharSourceRange Range(Parameter->getNameLoc(),
                              declarationName(Parameter).length());
        Results.push_back(DeclWithRange(Parameter, Range));
      }
    }
  }
  return Results;
}

std::string
ParameterExtractor::externalParameterName(const ParamDecl *Declaration) {
  return Declaration->getArgumentName().str().str();
}

std::string
ParameterExtractor::internalParameterName(const ParamDecl *Declaration) {
  return Declaration->getName().str().str();
}

std::pair<const AbstractFunctionDecl*, std::set<std::string>>
ParameterExtractor::
  getBaseOverridenDeclarationWithModules(const AbstractFunctionDecl *Declaration) {
  return Extractor::
    getBaseOverridenDeclarationWithModules<AbstractFunctionDecl>(Declaration);
}

llvm::Expected<std::string>
ParameterExtractor::parameterNameForCallSite(ParamDecl *Parameter) {

  auto Declaration = Parameter;

  if (const auto *FunctionDeclaration =
      dyn_cast<AbstractFunctionDecl>(Declaration->getDeclContext())) {

    if (Declaration->getNameLoc().isValid()) {

      auto IsSingle = Declaration->getArgumentNameLoc().isInvalid();

      auto Modules =
        getBaseOverridenDeclarationWithModules(FunctionDeclaration).second;

      auto isFromTheSameModule =
        isOverriddenMethodFromTheSameModule(Modules, moduleName(Declaration));

      if (IsSingle) {
        if (!isFromTheSameModule) {
          return stringError("We shouldn't rename parameter from outside "
                             "our module");
        }
        return internalParameterName(Declaration);

      } else {
        auto ExternalName = externalParameterName(Declaration);
        if (ExternalName.empty()) {
          return stringError("We cannot rename unnamed parameter");
        }
        if (!isFromTheSameModule) {
          return stringError("We shouldn't rename parameter from outside "
                             "our module");
        }
        return ExternalName;
      }
    }
    return stringError("We cannot rename this parameter");
  }
  return stringError("We cannot rename this parameter");
}

std::pair<const VarDecl*, std::set<std::string>>
VariableExtractor::
  getBaseOverridenDeclarationWithModules(const VarDecl *Declaration) {
  return Extractor::
    getBaseOverridenDeclarationWithModules<VarDecl>(Declaration);
}

llvm::Expected<ModuleNameAndParts>
VariableExtractor::
  variableIdentifierPartsFromContext(const VarDecl *Declaration) {

  std::string ModuleName;
  std::vector<std::string> Parts;

  auto ProtocolRequirements = Declaration->getSatisfiedProtocolRequirements();

  ProtocolDecl *ProtocolDeclaration = nullptr;
  if (auto *ExtensionDeclaration =
      dyn_cast<ExtensionDecl>(Declaration->getDeclContext())) {
    auto * Protocol =
      ExtensionDeclaration->getAsProtocolOrProtocolExtensionContext();
    ProtocolDeclaration = dyn_cast_or_null<ProtocolDecl>(Protocol);
  } else {
    ProtocolDeclaration =
    dyn_cast_or_null<ProtocolDecl>(Declaration->getDeclContext());
  }

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

llvm::Optional<DeclWithRange> TypeRepresentationExtractor::
handleComponent(ComponentIdentTypeRepr *Component) {
  auto StartLocation = Component->getStartLoc();
  if (Component->isBound() && StartLocation.isValid()) {
    auto TypeDeclaration = Component->getBoundDecl();
    CharSourceRange TypeRange(StartLocation,
                              TypeDeclaration->getName().getLength());
    return DeclWithRange(TypeDeclaration, TypeRange);
  }
  return llvm::None;
}

void TypeRepresentationExtractor::
  handleTypeRepresentationRecursively(std::vector<llvm::Optional<DeclWithRange>> &Declarations,
                                      TypeRepr *ParentOfTypeRepresentation,
                                      TypeRepr *TypeRepresentation) {

  // Guard agains the case in which there is no object
  // or the object points to itself in the AST.
  if (TypeRepresentation == nullptr
      || ParentOfTypeRepresentation == TypeRepresentation) {
    return;
  }

  if (auto *Compound = dyn_cast<CompoundIdentTypeRepr>(TypeRepresentation)) {
    for (auto *Component : Compound->Components) {
      Declarations.push_back(handleComponent(Component));
    }
  }

  if (auto *Generic = dyn_cast<GenericIdentTypeRepr>(TypeRepresentation)) {
    for (auto *GenericArg : Generic->getGenericArgs()) {
      handleTypeRepresentationRecursively(Declarations, Generic, GenericArg);
    }
  }

  if (auto *Component = dyn_cast<ComponentIdentTypeRepr>(TypeRepresentation)) {
    Declarations.push_back(handleComponent(Component));
  }

  if (auto *InOut = dyn_cast<InOutTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations, InOut, InOut->getBase());
  }

  if (auto *Attributed = dyn_cast<AttributedTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Attributed,
                                        Attributed->getTypeRepr());
  }

  if (auto *Function = dyn_cast<FunctionTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Function,
                                        Function->getArgsTypeRepr());
    handleTypeRepresentationRecursively(Declarations,
                                        Function,
                                        Function->getResultTypeRepr());
  }

  if (auto *IUO =
      dyn_cast<ImplicitlyUnwrappedOptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations, IUO, IUO->getBase());
  }

  if (auto *Protocol = dyn_cast<ProtocolTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Protocol,
                                        Protocol->getBase());
  }

  if (auto *Metatype = dyn_cast<MetatypeTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Metatype,
                                        Metatype->getBase());
  }

  if (auto *Array = dyn_cast<ArrayTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Array,
                                        Array->getBase());
  }

  if (auto *Dictionary = dyn_cast<DictionaryTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Dictionary,
                                        Dictionary->getKey());

    handleTypeRepresentationRecursively(Declarations,
                                        Dictionary,
                                        Dictionary->getValue());
  }

  if (auto *Optional = dyn_cast<OptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Declarations,
                                        Optional,
                                        Optional->getBase());
  }

  if (auto *Tuple = dyn_cast<TupleTypeRepr>(TypeRepresentation)) {
    for (auto *TupleElement : Tuple->getElements()) {
      handleTypeRepresentationRecursively(Declarations,
                                          Tuple,
                                          TupleElement);
    }
  }

  if (auto *Composition = dyn_cast<CompositionTypeRepr>(TypeRepresentation)) {
    for (auto *CompositionElement : Composition->getTypes()) {
      handleTypeRepresentationRecursively(Declarations,
                                          Composition,
                                          CompositionElement);
    }
  }
}

std::vector<DeclWithRange>
TypeRepresentationExtractor::
  declarationsFromTypeRepresentation(TypeRepr * TypeRepresentation) {
  std::vector<llvm::Optional<DeclWithRange>> Declarations;
  handleTypeRepresentationRecursively(Declarations,
                                      /* Parent */ nullptr,
                                      TypeRepresentation);
  std::vector<DeclWithRange> Results;
  for (auto &Declaration : Declarations) {
    if (Declaration != llvm::None) {
      Results.push_back(Declaration.getValue());
    }
  }
  return Results;
}

} //namespace obfuscation
} //namespace swift
