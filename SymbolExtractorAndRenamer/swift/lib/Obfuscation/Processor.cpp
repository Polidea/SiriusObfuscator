#include "swift/Obfuscation/Processor.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

Processor::~Processor() = default;

ExpressionProcessor::ExpressionProcessor(ParameterExtractor &Extractor)
: Extractor(Extractor) {}

llvm::Expected<AbstractFunctionDecl*>
ExpressionProcessor::
  declarationOfFunctionCalledInExpression(CallExpr *CallExpression) {
  auto *CallFn = CallExpression->getFn();

  if (auto *DotSyntaxCallExpression = dyn_cast<DotSyntaxCallExpr>(CallFn)) {
    auto *DotFn = DotSyntaxCallExpression->getFn();

    if (auto *OtherConstructor = dyn_cast<OtherConstructorDeclRefExpr>(DotFn)) {
      // It's a super call like super.init()
      auto *Decl = OtherConstructor->getDecl();

      if (auto *FunctionDeclaration =
          dyn_cast_or_null<AbstractFunctionDecl>(Decl)) {
        return FunctionDeclaration;
      }
    } else {
      // It's not a super.init call, just a function call
      if (auto *DeclRefExpression = dyn_cast<DeclRefExpr>(DotFn)) {
        auto *Decl = DeclRefExpression->getDecl();

        if (auto *FunctionDeclaration =
            dyn_cast_or_null<AbstractFunctionDecl>(Decl)) {
          return FunctionDeclaration;
        }
      }
    }
  } else if (auto *Constructor = dyn_cast<ConstructorRefCallExpr>(CallFn)) {
    // It's a constructor call
    auto * ConstructorFn = Constructor->getFn();

    if (auto *DeclarationRefExpression = dyn_cast<DeclRefExpr>(ConstructorFn)) {
      auto* Decl = DeclarationRefExpression->getDecl();

      if (auto *FunctionDeclaration =
          dyn_cast_or_null<AbstractFunctionDecl>(Decl)) {
        return FunctionDeclaration;
      }
    }
  } else if (auto *Expression = dyn_cast<Expr>(CallFn)) {
    // This branch is executed for example when
    // a function is being called inside set {} block
    auto *Decl = Expression->getReferencedDecl().getDecl();

    if (auto *FunctionDeclaration =
        dyn_cast_or_null<AbstractFunctionDecl>(Decl)) {
      return FunctionDeclaration;
    }
  }
  return stringError("Cannot found supported Call Expression subtree pattern");
}

std::vector<std::pair<Identifier, SourceLoc>>
ExpressionProcessor::validArguments(CallExpr *CallExpression) {

  std::vector<std::pair<Identifier, SourceLoc>> ValidArguments;

  for (unsigned i = 0; i < CallExpression->getNumArguments(); ++i) {
    auto Label = CallExpression->getArgumentLabels()[i];
    auto Location = CallExpression->getArgumentLabelLoc(i);
    if (Location.isValid()) {
      ValidArguments.push_back(std::make_pair(Label, Location));
    }
  }

  return ValidArguments;
}

DeclsWithRangesOrErrors
ExpressionProcessor::parseCallExpressionWithArguments(CallExpr* CallExpression) {

  DeclsWithRangesOrErrors Symbols;
  auto FunctionDeclarationOrError =
    declarationOfFunctionCalledInExpression(CallExpression);
  if (auto Error = FunctionDeclarationOrError.takeError()) {
    return wrapInVector<DeclWithRange>(std::move(Error));
  }
  auto FunctionDeclaration = FunctionDeclarationOrError.get();

  auto Parameters = Extractor.parametersFrom(FunctionDeclaration);

  auto ValidArguments = validArguments(CallExpression);
  for (size_t i = 0; i < ValidArguments.size(); ++i) {

    auto Label = ValidArguments[i].first;
    auto Location = ValidArguments[i].second;
    if (ValidArguments.size() == Parameters.size()) {
      // The same number of named arguments in call and
      // external/single parameters in function means that
      // there are no parameters in this function that are default
      // or with the external name
      auto Parameter = dyn_cast<ParamDecl>(Parameters[i].Declaration);
      auto ParameterNameOrError = Extractor.parameterNameForCallSite(Parameter);
      if (auto Error = ParameterNameOrError.takeError()) {
        llvm::consumeError(std::move(Error));
        continue;
      }
      auto ParameterName = ParameterNameOrError.get();
      if (Location.isValid() && ParameterName == Label.str().str()) {
        CharSourceRange Range(Location, Label.getLength());
        DeclWithRange DeclWithRange(Parameter, Range);
        DeclWithRange.Context = DeclarationProcessingContext::FunctionCallAttribute;
        Symbols.push_back(DeclWithRange);
      }

    } else {
      auto CopyOfParameters = Parameters;
      // There is different number of named arguments in call
      // and external/single parameters in function. It means that
      // some of the parameters are not required
      // (default or without external name)
      for (auto UncastParameter : CopyOfParameters) {
        auto Parameter = dyn_cast<ParamDecl>(UncastParameter.Declaration);
        auto ParameterNameOrError =
          Extractor.parameterNameForCallSite(Parameter);
        if (auto Error = ParameterNameOrError.takeError()) {
          llvm::consumeError(std::move(Error));
          continue;
        }
        auto ParameterName = ParameterNameOrError.get();
        if (Location.isValid() && ParameterName == Label.str().str()) {
          removeFromVector(CopyOfParameters, UncastParameter);
          CharSourceRange Range(Location, Label.getLength());
          DeclWithRange DeclWithRange(Parameter, Range);
          DeclWithRange.Context = DeclarationProcessingContext::FunctionCallAttribute;
          Symbols.push_back(DeclWithRange);
          break;
        }
      }
    }
  }

  return Symbols;
}

llvm::Expected<CharSourceRange>
ExpressionProcessor::rangeOfFirstOccurenceOfStringInSourceLoc(std::string String,
                                                              SourceLoc StartSourceLoc) {
  auto StartLoc =
  static_cast<const char*>(StartSourceLoc.getOpaquePointerValue());
  std::string StartLocString(StartLoc);

  auto FoundPosition = StartLocString.find(String);
  if (FoundPosition == std::string::npos) {
    return stringError("Failed to find the string occurence"
                       "in source location");
  }

  auto FirstOccurenceSourceLoc = StartSourceLoc.getAdvancedLoc(FoundPosition);
  return CharSourceRange(FirstOccurenceSourceLoc, String.size());
}

DeclsWithRangesOrErrors
ExpressionProcessor::parseGenericParameters(BoundGenericType *BoundGenericType,
                                            SourceLoc OpeningAngleBracketLoc) {
  DeclsWithRangesOrErrors Symbols;
  auto Parameters = BoundGenericType->getGenericArgs();
  for (auto Parameter : Parameters) {
    NominalTypeDecl *ParameterDecl = nullptr;
    if (OptionalType::classof(Parameter.getPointer())) {
      ParameterDecl =
      Parameter->getOptionalObjectType()->getAnyNominal();
    } else {
      ParameterDecl = Parameter->getAnyNominal();
    }
    if (ParameterDecl != nullptr) {
      auto ParameterName = ParameterDecl->getBaseName().getIdentifier().str();
      auto GenericArgRange =
        rangeOfFirstOccurenceOfStringInSourceLoc(ParameterName,
                                                 OpeningAngleBracketLoc);
      if (auto Error = GenericArgRange.takeError()) {
        Symbols.push_back(std::move(Error));
      } else {
        Symbols.push_back(DeclWithRange(ParameterDecl,
                                        GenericArgRange.get()));
      }
    }
    Symbols.push_back(stringError("Couldnt identify "
                                  "the generic parameter"));
  }
  return Symbols;
}

DeclsWithRangesOrErrors
ExpressionProcessor::parse(CallExpr* CallExpression) {
  if (CallExpression->hasArgumentLabelLocs()) {
    return parseCallExpressionWithArguments(CallExpression);
  }
  return wrapInVector<DeclWithRange>(stringError("Unsupported type of expression"));
}

// This function handles the specific case of `is` cast of non-optional
// to optional type or vice versa. In contrast to other castings
// (represented as is_subtype_expr), this kind of cast is represented
// in AST as enum_is_case_expr node. When parsing this kind of cast
// we don't get the callback in SymbolsWalkerAndCollector with NominalTypeDecl
// representing the CastType (cast-to type) so we have to extract it
// from the EnumIsCaseExpression.
DeclsWithRangesOrErrors
ExpressionProcessor::parse(EnumIsCaseExpr* EnumIsCaseExpression) {
  ExplicitCastExpr *ExplicitCastExpression = nullptr;

  // This callback invoked using forEachChildExpr() is used to extract the
  // declaration of the CastType and the location of the `is` keyword.
  const std::function<Expr*(Expr*)> &callback =
  [&ExplicitCastExpression](Expr* Child) -> Expr* {

    // We're looking for CoerceExpr (non-optional to optional type cast)
    // or ConditionalCheckedCastExpr (optional to non-optional type cast)
    // which both are subclasses of ExplicitCastExpr.
    if (ExplicitCastExpr::classof(Child)) {
      ExplicitCastExpression = dyn_cast<ExplicitCastExpr>(Child);
    }

    return Child;
  };
  EnumIsCaseExpression->forEachChildExpr(callback);

  if (ExplicitCastExpression != nullptr) {
    auto CastType = ExplicitCastExpression->getCastTypeLoc().getType();

    // The data representing the location of the CastType in the expression
    // seems to be impossible to retrieve from the EnumIsCastExpression
    // and its subexpressions. We have to calculate the CastType location
    // later using `is` keyword and CastType name.
    auto IsKeywordSourceLoc = ExplicitCastExpression->getAsLoc();

    Type UnwrappedCastType;
    if (ConditionalCheckedCastExpr::classof(ExplicitCastExpression)) {
      UnwrappedCastType = CastType;
    } else if (CoerceExpr::classof(ExplicitCastExpression)) {
      UnwrappedCastType = CastType->getOptionalObjectType();
    } else {
      return wrapInVector<DeclWithRange>(stringError("Unsupported type of explicit cast expression"));
    }

    NominalTypeDecl *CastTypeDeclaration = UnwrappedCastType->getAnyNominal();

    if (CastTypeDeclaration != nullptr) {

      auto CastTypeName =
      CastTypeDeclaration->getBaseName().getIdentifier().str();
      auto CastTypeRange =
        rangeOfFirstOccurenceOfStringInSourceLoc(CastTypeName,
                                                 IsKeywordSourceLoc);
      if (auto Error = CastTypeRange.takeError()) {
        return wrapInVector<DeclWithRange>(std::move(Error));
      }

      DeclsWithRangesOrErrors Symbols;
      Symbols.push_back(DeclWithRange(CastTypeDeclaration,
                                      CastTypeRange.get()));

      if (auto *GenericBoundType =
          dyn_cast<BoundGenericType>(UnwrappedCastType.getPointer())) {

        auto GenericNameEndLoc = CastTypeRange.get().getEnd();
        auto OpeningAngleBracketRange =
          rangeOfFirstOccurenceOfStringInSourceLoc("<", GenericNameEndLoc);
        if (auto Error = OpeningAngleBracketRange.takeError()) {
          return wrapInVector<DeclWithRange>(std::move(Error));
        }
        auto OpeningAngleBracketLoc = OpeningAngleBracketRange.get().getStart();

        auto GenericParamsSymbols =
          parseGenericParameters(GenericBoundType, OpeningAngleBracketLoc);

        for (auto Iterator = GenericParamsSymbols.begin();
             Iterator != GenericParamsSymbols.end();
             ++Iterator) {
          Symbols.push_back(std::move(*Iterator));
        }
      }

      return Symbols;
    }
  }

  return wrapInVector<DeclWithRange>(stringError("Failed to extract the cast-to type symbol"
                                  "from the EnumIsCase expression"));
}

DeclsWithRangesOrErrors ExpressionProcessor::declarationFrom(Expr *Expression) {

  if (auto *CallExpression = dyn_cast<CallExpr>(Expression)) {
    return parse(CallExpression);
  } else if (auto *EnumIsCaseExpression = dyn_cast<EnumIsCaseExpr>(Expression)) {
    // Expression of `is` casting non-optional to optional type or vice versa.
    return parse(EnumIsCaseExpression);
  }

  return wrapInVector<DeclWithRange>(stringError("Unsupported type of expression"));
}

DeclsWithRangesOrErrors ExpressionProcessor::declarationFrom(Decl *Declaration) {
  return DeclsWithRangesOrErrors();
}

DeclsWithRangesOrErrors WhereClauseProcessor::declarationFrom(Expr *Expression) {
  return DeclsWithRangesOrErrors();
}

WhereClauseProcessor::
  WhereClauseProcessor(TypeRepresentationExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithRangesOrErrors
WhereClauseProcessor::handleWhereClause(TrailingWhereClause *WhereClause) {

  DeclsWithRangesOrErrors Results;

  if (WhereClause == nullptr) { return Results; }

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
      for (auto &Declaration :
           Extractor.declarationsFromTypeRepresentation(FirstTypeRepresentation)) {
        Results.push_back(Declaration);
      }
    }
    if (SecondTypeRepresentation != nullptr
        && !SecondTypeRepresentation->isInvalid()) {
      for (auto &Declaration :
           Extractor.declarationsFromTypeRepresentation(SecondTypeRepresentation)) {
        Results.push_back(Declaration);
      }
    }
  }
  return Results;
}

DeclsWithRangesOrErrors WhereClauseProcessor::declarationFrom(Decl *Declaration) {
  if (Declaration != nullptr) {

    // We need to cast to the right type because there's no one base type
    // defining the `getTrailingWhereClause` function in all the supported
    // cases.
    if (auto *Extension = dyn_cast<ExtensionDecl>(Declaration)) {
      return handleWhereClause(Extension->getTrailingWhereClause());

    } else if (auto *GenericType = dyn_cast<GenericTypeDecl>(Declaration)) {
      return handleWhereClause(GenericType->getTrailingWhereClause());

    } else if (auto *Subscript = dyn_cast<SubscriptDecl>(Declaration)) {
      return handleWhereClause(Subscript->getTrailingWhereClause());

    } else if (auto *AbstractFunc = dyn_cast<AbstractFunctionDecl>(Declaration)) {
      return handleWhereClause(AbstractFunc->getTrailingWhereClause());

    } else if (auto *Associated = dyn_cast<AssociatedTypeDecl>(Declaration)) {
      return handleWhereClause(Associated->getTrailingWhereClause());
    }
  }
  return DeclsWithRangesOrErrors();
}

} //namespace obfuscation
} //namespace swift
