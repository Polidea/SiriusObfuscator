#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/OperatorParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {
  
SymbolsOrError extractSymbol(Decl* Declaration, CharSourceRange Range) {
  
  std::unique_ptr<SingleSymbolOrError> SingleSymbolOrErrorPointer(nullptr);
  std::unique_ptr<SymbolsOrError> SymbolsOrErrorPointer(nullptr);
  
  if (const auto *NominalTypeDeclaration =
        dyn_cast<NominalTypeDecl>(Declaration)) {
    SingleSymbolOrErrorPointer =
      llvm::make_unique<SingleSymbolOrError>(parse(NominalTypeDeclaration));
  } else if (const auto *FuncDeclaration = dyn_cast<FuncDecl>(Declaration)) {
      if (FuncDeclaration->isOperator()) {
          SymbolsOrErrorPointer =
          llvm::make_unique<SymbolsOrError>(parseOperator(FuncDeclaration, Range));
      } else {
          SymbolsOrErrorPointer =
          llvm::make_unique<SymbolsOrError>(parse(FuncDeclaration, Range));
      }
  } else if (const auto *OperatorDeclaration = dyn_cast<OperatorDecl>(Declaration)) {
      SingleSymbolOrErrorPointer =
      llvm::make_unique<SingleSymbolOrError>(parse(OperatorDeclaration));
  } else if (const auto *ConstructDeclaration = dyn_cast<ConstructorDecl>(Declaration)) {
      SymbolsOrErrorPointer =
      llvm::make_unique<SymbolsOrError>(parse(ConstructDeclaration, Range));
  } else if (const auto *ParamDeclaration = dyn_cast<ParamDecl>(Declaration)) {
    auto Symbols = parseSeparateDeclarationWithRange(ParamDeclaration, Range);
    SymbolsOrErrorPointer =
      llvm::make_unique<SymbolsOrError>(std::move(Symbols));
  } else if (const auto *VariableDeclaration = dyn_cast<VarDecl>(Declaration)) {
    SingleSymbolOrErrorPointer =
      llvm::make_unique<SingleSymbolOrError>(parse(VariableDeclaration));
  } else {
    return stringError("unsupported declaration type");
  }
  
  if (SingleSymbolOrErrorPointer) {
    if (auto Error = SingleSymbolOrErrorPointer->takeError()) {
      return std::move(Error);
    }
    SymbolWithRange Symbol(SingleSymbolOrErrorPointer->get(), Range);
    return std::vector<SymbolWithRange> { Symbol };
  } else if (SymbolsOrErrorPointer) {
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
