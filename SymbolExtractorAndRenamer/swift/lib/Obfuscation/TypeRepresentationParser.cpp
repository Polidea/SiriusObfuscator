#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/TypeRepresentationParser.h"

namespace swift {
namespace obfuscation {

void TypeRepresentationParser::handleComponent(
                                       GlobalCollectedSymbols &CollectedSymbols,
                                       ComponentIdentTypeRepr *Component) {
  auto StartLocation = Component->getStartLoc();
  if (Component->isBound() && StartLocation.isValid()) {
    auto TypeDeclaration = Component->getBoundDecl();
    CharSourceRange TypeRange(StartLocation,
                              TypeDeclaration->getName().getLength());
    auto SymbolsOrError = extractSymbol(CollectedSymbols,
                                        TypeDeclaration,
                                        TypeRange);
    if (auto Error = SymbolsOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      return;
    }
    copyToSet(SymbolsOrError.get(), Symbols);
  }
}

void TypeRepresentationParser::
handleTypeRepresentationRecursively(GlobalCollectedSymbols &CollectedSymbols,
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
      handleComponent(CollectedSymbols, Component);
    }
  }

  if (auto *Generic = dyn_cast<GenericIdentTypeRepr>(TypeRepresentation)) {
    for (auto *GenericArg : Generic->getGenericArgs()) {
      handleTypeRepresentationRecursively(CollectedSymbols,
                                          Generic,
                                          GenericArg);
    }
  }

  if (auto *Component = dyn_cast<ComponentIdentTypeRepr>(TypeRepresentation)) {
    handleComponent(CollectedSymbols, Component);
  }

  if (auto *InOut = dyn_cast<InOutTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        InOut,
                                        InOut->getBase());
  }

  if (auto *Attributed = dyn_cast<AttributedTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Attributed,
                                        Attributed->getTypeRepr());
  }

  if (auto *Function = dyn_cast<FunctionTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Function,
                                        Function->getArgsTypeRepr());
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Function,
                                        Function->getResultTypeRepr());
  }

  if (auto *IUO =
        dyn_cast<ImplicitlyUnwrappedOptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,IUO, IUO->getBase());
  }

  if (auto *Protocol = dyn_cast<ProtocolTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Protocol,
                                        Protocol->getBase());
  }

  if (auto *Metatype = dyn_cast<MetatypeTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Metatype,
                                        Metatype->getBase());
  }

  if (auto *Array = dyn_cast<ArrayTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Array,
                                        Array->getBase());
  }

  if (auto *Dictionary = dyn_cast<DictionaryTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Dictionary,
                                        Dictionary->getKey());
    
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Dictionary,
                                        Dictionary->getValue());
  }

  if (auto *Optional = dyn_cast<OptionalTypeRepr>(TypeRepresentation)) {
    handleTypeRepresentationRecursively(CollectedSymbols,
                                        Optional,
                                        Optional->getBase());
  }

  if (auto *Tuple = dyn_cast<TupleTypeRepr>(TypeRepresentation)) {
    for (auto *TupleElement : Tuple->getElements()) {
      handleTypeRepresentationRecursively(CollectedSymbols,
                                          Tuple,
                                          TupleElement);
    }
  }

  if (auto *Composition = dyn_cast<CompositionTypeRepr>(TypeRepresentation)) {
    for (auto *CompositionElement : Composition->getTypes()) {
      handleTypeRepresentationRecursively(CollectedSymbols,
                                          Composition,
                                          CompositionElement);
    }
  }
}

void TypeRepresentationParser::
  collectSymbolsFromTypeRepresentation(GlobalCollectedSymbols &CollectedSymbols,
                                       TypeRepr *TypeRepresentation) {
  handleTypeRepresentationRecursively(CollectedSymbols,
                                      /* Parent */ nullptr,
                                      TypeRepresentation);
}

std::set<SymbolWithRange> TypeRepresentationParser::harvestSymbols() {
  std::set<SymbolWithRange> Result = Symbols;
  Symbols.clear();
  return Result;
}

} //namespace obfuscation
} //namespace swift
