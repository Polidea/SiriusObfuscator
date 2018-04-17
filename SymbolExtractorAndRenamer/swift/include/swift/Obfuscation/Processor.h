#ifndef Processor_h
#define Processor_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Extractor.h"

namespace swift {
namespace obfuscation {

class Processor {

public:

  virtual ~Processor() = 0;

  virtual DeclsWithRangesOrErrors declarationFrom(Expr *) = 0;

  virtual DeclsWithRangesOrErrors declarationFrom(Decl *) = 0;

};

class ExpressionProcessor : public Processor {

private:

  ParameterExtractor Extractor;

  DeclsWithRangesOrErrors parse(CallExpr *);

  DeclsWithRangesOrErrors parseCallExpressionWithArguments(CallExpr *);

  DeclsWithRangesOrErrors parse(EnumIsCaseExpr *);

  llvm::Expected<AbstractFunctionDecl*>
  declarationOfFunctionCalledInExpression(CallExpr *);

  std::vector<std::pair<Identifier, SourceLoc>>
  validArguments(CallExpr *CallExpression);

  llvm::Expected<CharSourceRange>
  rangeOfFirstOccurenceOfStringInSourceLoc(std::string String,
                                           SourceLoc StartSourceLoc);

  DeclsWithRangesOrErrors
  parseGenericParameters(BoundGenericType *BoundGenericType,
                         SourceLoc OpeningAngleBracketLoc);

public:

  ExpressionProcessor(ParameterExtractor &Extractor);

  DeclsWithRangesOrErrors declarationFrom(Expr *) override;
  DeclsWithRangesOrErrors declarationFrom(Decl *) override;

};

class WhereClauseProcessor : public Processor {

private:

  TypeRepresentationExtractor Extractor;

  DeclsWithRangesOrErrors handleWhereClause(TrailingWhereClause *);

public:

  WhereClauseProcessor(TypeRepresentationExtractor &);

  DeclsWithRangesOrErrors declarationFrom(Expr *) override;
  DeclsWithRangesOrErrors declarationFrom(Decl *) override;

};

} //namespace obfuscation
} //namespace swift

#endif /* Processor_h */
