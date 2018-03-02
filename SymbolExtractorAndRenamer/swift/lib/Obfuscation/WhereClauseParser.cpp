#include "swift/Obfuscation/WhereClauseParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/TypeRepresentationParser.h"

namespace swift {
namespace obfuscation {

void WhereClauseParser::handleWhereClause(
                                      GlobalCollectedSymbols &CollectedSymbols,
                                      TrailingWhereClause *WhereClause) {
  if (WhereClause == nullptr) { return; }
  TypeRepresentationParser TypeReprParser;
  auto Requirements = WhereClause->getRequirements();
  for (auto WhereRequirement : Requirements) {
    if (WhereRequirement.isInvalid()) { continue; }
    TypeRepr *FirstTypeRepresentation = nullptr;
    TypeRepr *SecondTypeRepresentation = nullptr;
    switch (WhereRequirement.getKind()) {
      case RequirementReprKind::TypeConstraint: {
        FirstTypeRepresentation = WhereRequirement.getSubjectRepr();
        SecondTypeRepresentation = WhereRequirement.getConstraintRepr();
        break;
      }
      case RequirementReprKind::SameType: {
        FirstTypeRepresentation = WhereRequirement.getFirstTypeRepr();
        SecondTypeRepresentation = WhereRequirement.getSecondTypeRepr();
        break;
      }
      case RequirementReprKind::LayoutConstraint: {
        FirstTypeRepresentation = WhereRequirement.getSubjectRepr();
        SecondTypeRepresentation = nullptr;
        // The secont part of Layout constaint is Layout,
        // which we think there is no need to rename
        break;
      }
    }

    if (FirstTypeRepresentation != nullptr
        && !FirstTypeRepresentation->isInvalid()) {
      TypeReprParser
        .collectSymbolsFromTypeRepresentation(CollectedSymbols,
                                              FirstTypeRepresentation);
    }
    if (SecondTypeRepresentation != nullptr
        && !SecondTypeRepresentation->isInvalid()) {
      TypeReprParser
        .collectSymbolsFromTypeRepresentation(CollectedSymbols,
                                              SecondTypeRepresentation);
    }
  }
  copyToSet(TypeReprParser.harvestSymbols(), Symbols);
}

void WhereClauseParser::collectSymbolsFromDeclaration(
                                      GlobalCollectedSymbols &CollectedSymbols,
                                      Decl* Declaration) {
  if (Declaration != nullptr) {
    if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols, Extension->getTrailingWhereClause());
    } else if (auto *GenericType = dyn_cast<GenericTypeDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols, GenericType->getTrailingWhereClause());
    } else if (auto *Subscript = dyn_cast<SubscriptDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols, Subscript->getTrailingWhereClause());
    } else if (auto *AbstractFunc = dyn_cast<AbstractFunctionDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols, AbstractFunc->getTrailingWhereClause());
    } else if (auto *Associated = dyn_cast<AssociatedTypeDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols, Associated->getTrailingWhereClause());
    }
  }
}

std::set<SymbolWithRange> WhereClauseParser::harvestSymbols() {
  std::set<SymbolWithRange> Result = Symbols;
  Symbols.clear();
  return Result;
}

} //namespace obfuscation
} //namespace swift
