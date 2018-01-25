#include "swift/Obfuscation/ExpressionParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {
  
llvm::Expected<FuncDecl*>
declarationOfFunctionCalledInExpression(CallExpr *CallExpression) {
  if (auto *DotSyntaxCallExpression =
        dyn_cast<DotSyntaxCallExpr>(CallExpression->getFn())) {
    if (auto *DeclarationRefExpression =
          dyn_cast<DeclRefExpr>(DotSyntaxCallExpression->getFn())) {
      if (auto *FunctionDeclaration =
            dyn_cast<FuncDecl>(DeclarationRefExpression->getDecl())) {
        return FunctionDeclaration;
      }
    }
  }
  return stringError("Cannot found supported Call Expression subtree pattern");
}
  
std::vector<std::pair<Identifier, SourceLoc>>
validArguments(CallExpr *CallExpression) {

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
  
SymbolsOrError parseCallExpressionWithArguments(CallExpr* CallExpression) {
  
  std::vector<SymbolWithRange> Symbols;
  auto FunctionDeclarationOrError =
    declarationOfFunctionCalledInExpression(CallExpression);
  if (auto Error = FunctionDeclarationOrError.takeError()) {
    return std::move(Error);
  }
  auto FunctionDeclaration = FunctionDeclarationOrError.get();
  
  auto SymbolsOrError =
    parseFunctionFromCallExpressionForParameters(FunctionDeclaration);
  if (auto Error = SymbolsOrError.takeError()) {
    return std::move(Error);
  }
  
  auto ValidArguments = validArguments(CallExpression);
  
  if (ValidArguments.size() != SymbolsOrError.get().size()) {
    return stringError("Unsupported call expression");
  }
    
  for (unsigned i = 0; i < ValidArguments.size(); ++i) {
    auto Symbol = SymbolsOrError.get()[i];
    auto Label = ValidArguments[i].first;
    auto Location = ValidArguments[i].second;
    if (Location.isValid() && Symbol.Symbol.Name == Label.str().str()) {
      auto Range = CharSourceRange(Location, Label.getLength());
      Symbols.push_back(SymbolWithRange(Symbol.Symbol, Range));
    }
  }

  return Symbols;
}

SymbolsOrError parse(CallExpr* CallExpression) {
  if (CallExpression->hasArgumentLabelLocs()) {
    return parseCallExpressionWithArguments(CallExpression);
  }
  return stringError("Unsupported type of expression");
}

SymbolsOrError extractSymbol(Expr* Expression) {
  if (auto *CallExpression = dyn_cast<CallExpr>(Expression)) {
    return parse(CallExpression);
  }
  return stringError("Unsupported type of expression");
}
  
} //namespace obfuscation
} //namespace swift
