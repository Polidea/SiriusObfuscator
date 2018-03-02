#include "swift/Obfuscation/WhereClauseParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/TypeRepresentationParser.h"

namespace swift {
namespace obfuscation {

void
WhereClauseParser::handleWhereClause(GlobalCollectedSymbols &CollectedSymbols,
                                     TrailingWhereClause *WhereClause) {

  if (WhereClause == nullptr) { return; }

  TypeRepresentationParser TypeReprParser;

  auto Requirements = WhereClause->getRequirements();
  for (auto WhereRequirement : Requirements) {

    if (WhereRequirement.isInvalid()) { continue; }

    TypeRepr *FirstTypeRepresentation = nullptr;
    TypeRepr *SecondTypeRepresentation = nullptr;

    switch (WhereRequirement.getKind()) {
      // This represents the constraint to type,
      // like "Self: UIView" or "Element: Hashable"
      case RequirementReprKind::TypeConstraint: {
        // In case of type constraints, the left side of ":" colon sign is
        // represented as Subject, and the right side as Constraint
        FirstTypeRepresentation = WhereRequirement.getSubjectRepr();
        SecondTypeRepresentation = WhereRequirement.getConstraintRepr();
        break;
      }
      // This represents the type equality requirements, such as
      // "Self == UIView" or "Element == String"
      case RequirementReprKind::SameType: {
        // In case of type equality requirement the type on the left side
        // of "==" sign is represented as FirstType and the type
        // on the right side is represented as SecondType
        FirstTypeRepresentation = WhereRequirement.getFirstTypeRepr();
        SecondTypeRepresentation = WhereRequirement.getSecondTypeRepr();
        break;
      }
      // This represents the constraint on the type itself.
      // The only user-facing case that we know of is "Protocol: class",
      // but it might represent other situations internal to compiler
      // or private to stdlib
      case RequirementReprKind::LayoutConstraint: {
        // The left side of the layout constraint is represented as Subject.
        // The right side of Layout constaint is Layout,
        // which we think there is no need to rename
        FirstTypeRepresentation = WhereRequirement.getSubjectRepr();
        SecondTypeRepresentation = nullptr;
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

    // We need to cast to the right type because there's no one base type
    // defining the `getTrailingWhereClause` function in all the supported
    // cases.
    if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols,
                        Extension->getTrailingWhereClause());

    } else if (auto *GenericType = dyn_cast<GenericTypeDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols,
                        GenericType->getTrailingWhereClause());

    } else if (auto *Subscript = dyn_cast<SubscriptDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols,
                        Subscript->getTrailingWhereClause());

    } else if (auto *AbstractFunc = dyn_cast<AbstractFunctionDecl>(Declaration)) {
      handleWhereClause(CollectedSymbols,
                        AbstractFunc->getTrailingWhereClause());

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
