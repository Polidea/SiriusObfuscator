#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/TypeRepresentationParser.h"

namespace swift {
namespace obfuscation {

void TypeRepresentationParser::handleComponent(ComponentIdentTypeRepr *Component) {
  auto StartLocation = Component->getStartLoc();
  if (Component->isBound() && StartLocation.isValid()) {
    auto TypeDeclaration = Component->getBoundDecl();
    CharSourceRange TypeRange(StartLocation,
                              TypeDeclaration->getName().getLength());
    auto SymbolsOrError = extractSymbol(TypeDeclaration, TypeRange);
    if (auto Error = SymbolsOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      return;
    }
    copyToSet(SymbolsOrError.get(), Symbols);
  }
}

void TypeRepresentationParser::
handleTypeRepresentationRecursively(TypeRepr *ParentOfTypeRepresentation,
                                    TypeRepr *TypeRepresentation) {

  // Guard agains the case in which there is no object
  // or the object points to itself in the AST.
  if (TypeRepresentation == nullptr
      || ParentOfTypeRepresentation == TypeRepresentation) {
    return;
  }

  if (auto *Compound = dyn_cast<CompoundIdentTypeRepr>(TypeRepresentation)) {
    for (auto *Component : Compound->Components) {
      handleComponent(Component);
    }
  }

  if (auto *Generic = dyn_cast<GenericIdentTypeRepr>(TypeRepresentation)) {
    for (auto *GenericArg : Generic->getGenericArgs()) {
      handleTypeRepresentationRecursively(Generic, GenericArg);
    }
  }

  if (auto *Component = dyn_cast<ComponentIdentTypeRepr>(TypeRepresentation)) {
    handleComponent(Component);
  }

  if (auto *InOut = dyn_cast<InOutTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(InOut, InOut->getBase());
  }

  if (auto *Attributed = dyn_cast<AttributedTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Attributed,
                                        Attributed->getTypeRepr());
  }

  if (auto *Function = dyn_cast<FunctionTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Function,
                                        Function->getArgsTypeRepr());
    handleTypeRepresentationRecursively(Function,
                                        Function->getResultTypeRepr());
  }

  if (auto *IUO =
        dyn_cast<ImplicitlyUnwrappedOptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(IUO, IUO->getBase());
  }

  if (auto *Protocol = dyn_cast<ProtocolTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Protocol, Protocol->getBase());
  }

  if (auto *Metatype = dyn_cast<MetatypeTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Metatype, Metatype->getBase());
  }

  if (auto *Array = dyn_cast<ArrayTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Array, Array->getBase());
  }

  if (auto *Dictionary = dyn_cast<DictionaryTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Dictionary, Dictionary->getKey());
    handleTypeRepresentationRecursively(Dictionary, Dictionary->getValue());
  }

  if (auto *Optional = dyn_cast<OptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(Optional, Optional->getBase());
  }

  if (auto *Tuple = dyn_cast<TupleTypeRepr>(TypeRepresentation)) {
    for (auto *TupleElement : Tuple->getElements()) {
      handleTypeRepresentationRecursively(Tuple, TupleElement);
    }
  }

  if (auto *Composition = dyn_cast<CompositionTypeRepr>(TypeRepresentation)) {
    for (auto *CompositionElement : Composition->getTypes()) {
      handleTypeRepresentationRecursively(Composition, CompositionElement);
    }
  }
}

void TypeRepresentationParser::
  collectSymbolsFromTypeRepresentation(TypeRepr *TypeRepresentation) {
  handleTypeRepresentationRecursively(/* Parent */ nullptr,
                                      TypeRepresentation);
}

std::set<SymbolWithRange> TypeRepresentationParser::harvestSymbols() {
  std::set<SymbolWithRange> Result = Symbols;
  Symbols.clear();
  return Result;
}

} //namespace obfuscation
} //namespace swift
