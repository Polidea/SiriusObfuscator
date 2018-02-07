#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/ExpressionParser.h"

#include <string>

namespace swift {
namespace obfuscation {

struct RenamesCollector: public SourceEntityWalker {
  std::set<SymbolWithRange> Bucket;
  
  void handleSymbols(std::vector<SymbolWithRange> &Symbols) {
    for (auto &Symbol : Symbols) {
      Bucket.insert(Symbol);
    }
  }

  bool walkToExprPre(Expr *Expression) override {
    auto Symbols = extractSymbol(Expression);
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbols(Symbols.get());
    return true;
  }
  
  bool walkToDeclPre(Decl *Declaration, CharSourceRange Range) override {
    if (Declaration->isImplicit()) {
      return false;
    }
    auto Symbols = extractSymbol(Declaration, Range);
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbols(Symbols.get());
    return true;
  }
  
  bool visitDeclReference(ValueDecl *Declaration, CharSourceRange Range,
                          TypeDecl *CtorTyRef, ExtensionDecl *ExtTyRef,
                          Type T, ReferenceMetaData Data) override {
    
    std::unique_ptr<SymbolsOrError> Symbols(nullptr);
    if (CtorTyRef) {
      Symbols =
        llvm::make_unique<SymbolsOrError>(extractSymbol(CtorTyRef, Range));
    } else {
      Symbols =
        llvm::make_unique<SymbolsOrError>(extractSymbol(Declaration, Range));
    }
    if (auto Error = Symbols->takeError()) {
      llvm::handleAllErrors(std::move(Error),
                            [](const llvm::StringError &StringError) {
        llvm::errs() << "Error: " << StringError.message();
      });
      return true;
    }
    handleSymbols(Symbols->get());
    return true;
  }
};

std::set<SymbolWithRange> walkAndCollectSymbols(SourceFile &SourceFile) {
  RenamesCollector Collector;
  Collector.walk(SourceFile);
  return Collector.Bucket;
}

} //namespace obfuscation
} //namespace swift
