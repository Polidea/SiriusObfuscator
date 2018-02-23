#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/OperatorParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

bool isNominal(Decl* Declaration) {
  return dyn_cast<NominalTypeDecl>(Declaration) != nullptr;
}

bool isFunc(Decl* Declaration) {
  return dyn_cast<FuncDecl>(Declaration) != nullptr;
}

bool isOperator(Decl* Declaration) {
  return dyn_cast<OperatorDecl>(Declaration) != nullptr;
}

bool isConstructor(Decl* Declaration) {
  return dyn_cast<ConstructorDecl>(Declaration) != nullptr;
}

bool isParam(Decl* Declaration) {
  return dyn_cast<ParamDecl>(Declaration) != nullptr;
}

bool isVariable(Decl* Declaration) {
  return dyn_cast<VarDecl>(Declaration) != nullptr;
}

std::unique_ptr<SymbolsOrError>
appendRangeToSymbol(SingleSymbolOrError &&SymbolOrError, CharSourceRange Range) {
  if (auto Error = SymbolOrError.takeError()) {
    return llvm::make_unique<SymbolsOrError>(std::move(Error));
  }
  std::vector<SymbolWithRange> Symbols { SymbolWithRange(SymbolOrError.get(),
                                                         Range) };
  return llvm::make_unique<SymbolsOrError>(Symbols);
}

std::unique_ptr<SymbolsOrError> parseAsNominal(Decl* Declaration,
                                                    CharSourceRange Range) {
  auto NominalDeclaration = dyn_cast<NominalTypeDecl>(Declaration);
  return appendRangeToSymbol(parse(NominalDeclaration), Range);
}

std::unique_ptr<SymbolsOrError> parseAsFunction(Decl* Declaration,
                                                CharSourceRange Range) {
  auto FunctionDeclaration = dyn_cast<FuncDecl>(Declaration);
  if (FunctionDeclaration->isOperator()) {
    return llvm::make_unique<SymbolsOrError>(parseOperator(FunctionDeclaration,
                                                           Range));
  } else {
    return llvm::make_unique<SymbolsOrError>(parse(FunctionDeclaration,
                                                   Range));
  }
}

std::unique_ptr<SymbolsOrError> parseAsOperator(Decl* Declaration,
                                                CharSourceRange Range) {
  const auto *OperatorDeclaration = dyn_cast<OperatorDecl>(Declaration);
  return appendRangeToSymbol(parse(OperatorDeclaration), Range);
}

std::unique_ptr<SymbolsOrError> parseAsConstructor(Decl* Declaration,
                                                   CharSourceRange Range) {
  const auto *ConstructorDeclaration = dyn_cast<ConstructorDecl>(Declaration);
  return llvm::make_unique<SymbolsOrError>(parse(ConstructorDeclaration,
                                                 Range));
}

std::unique_ptr<SymbolsOrError> parseAsParam(Decl* Declaration,
                                             CharSourceRange Range) {
  const auto *ParamDeclaration = dyn_cast<ParamDecl>(Declaration);
  auto Symbols = parseSeparateDeclarationWithRange(ParamDeclaration, Range);
  return llvm::make_unique<SymbolsOrError>(std::move(Symbols));
}

std::unique_ptr<SymbolsOrError> parseAsVariable(Decl* Declaration,
                                                CharSourceRange Range) {
  const auto *VariableDeclaration = dyn_cast<VarDecl>(Declaration);
  return appendRangeToSymbol(parse(VariableDeclaration), Range);
}

SymbolsOrError extractSymbol(Decl* Declaration, CharSourceRange Range) {

  std::unique_ptr<SymbolsOrError> SymbolsOrErrorPointer(nullptr);

  if (isNominal(Declaration)) {
    SymbolsOrErrorPointer = parseAsNominal(Declaration, Range);
  } else if (isFunc(Declaration)) {
    SymbolsOrErrorPointer = parseAsFunction(Declaration, Range);
  } else if (isOperator(Declaration)) {
    SymbolsOrErrorPointer = parseAsOperator(Declaration, Range);
  } else if (isConstructor(Declaration)) {
    SymbolsOrErrorPointer = parseAsConstructor(Declaration, Range);
  } else if (isParam(Declaration)) {
    SymbolsOrErrorPointer = parseAsParam(Declaration, Range);
  } else if (isVariable(Declaration)) {
    SymbolsOrErrorPointer = parseAsVariable(Declaration, Range);
  } else {
    return stringError("unsupported declaration type");
  }

  if (SymbolsOrErrorPointer != nullptr) {
    if (auto Error = SymbolsOrErrorPointer->takeError()) {
      return std::move(Error);
    }
    return SymbolsOrErrorPointer->get();
  } else {
    return stringError("unsupported declaration type");
  }
}
  
} //namespace obfuscation
} //namespace swift
