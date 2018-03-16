#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/ExpressionParser.h"
#include "swift/Obfuscation/ExtensionExcluder.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils-Template.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/WhereClauseParser.h"

#include <string>

namespace swift {
namespace obfuscation {

struct SymbolsWalkerAndCollector: public SourceEntityWalker {

  static int SymbolIndex;

  // This is a vector that stores all of the collected IndexedSymbolWithRange
  // thet are compared by symbol and range
  GlobalCollectedSymbols Symbols;

  std::set<Excluder*> &Excluders;
  
  SymbolsWalkerAndCollector(std::set<Excluder*> &Excluders)
                                                      : Excluders(Excluders) {}

// Overriden methods called back as the AST is walked

  bool walkToExprPre(Expr *Expression) override {
    auto Symbols = extractSymbol(Expression);
    handleExtractionResult(Symbols);
    return true;
  }
  
  bool walkToDeclPre(Decl *Declaration, CharSourceRange Range) override {
    auto ExtractedSymbols = extractSymbol(Symbols, Declaration, Range);
    handleExtractionResult(ExtractedSymbols);
    identifyExclusions(Declaration);
    return true;
  }

  void handleWhereClausesIfNeeded(const std::vector<Decl*> &&Declarations) {
    WhereClauseParser WhereClauseParser;
    for (auto *Declaration : Declarations) {
      WhereClauseParser.collectSymbolsFromDeclaration(Symbols, Declaration);
    }
    handleSymbols(WhereClauseParser.harvestSymbols());
  }

  // We need to extract symbols here even though we might have already seen
  // this node in the walkToDeclPre because here we have additional
  // contextual information like CtorTyRef
  bool visitDeclReference(ValueDecl *Declaration,
                          CharSourceRange Range,
                          TypeDecl *CtorTyRef,
                          ExtensionDecl *ExtTyRef,
                          Type T,
                          ReferenceMetaData Data) override {

    handleWhereClausesIfNeeded({ Declaration, CtorTyRef, ExtTyRef });

    auto ExtractedSymbols = extractSymbol(Symbols,
                                          CtorTyRef ? CtorTyRef : Declaration,
                                          Range);
    handleExtractionResult(ExtractedSymbols);

    identifyExclusions(ExtTyRef);
    identifyExclusions(Declaration);
    identifyExclusions(CtorTyRef);
    
    return true;
  }

// Methods for handling the extracted symbols

  void identifyExclusions(Decl* Declaration) {
    if(Declaration != nullptr) {
      for(auto Excluder: Excluders) {
        Excluder->identifyExclusions(Declaration);
      }
    }
  }
  
  void handleSymbol(const SymbolWithRange &Symbol) {
    auto InsertionResult =
      Symbols.insert(IndexedSymbolWithRange(SymbolIndex, Symbol));
    if (InsertionResult.second == true) {
      ++SymbolsWalkerAndCollector::SymbolIndex;
    }
  }

  void handleSymbols(std::vector<SymbolWithRange> &Symbols) {
    for (const auto &Symbol : Symbols) {
      handleSymbol(Symbol);
    }
  }

  void handleSymbols(std::set<SymbolWithRange> &&Symbols) {
    for (const auto &Symbol : Symbols) {
      handleSymbol(Symbol);
    }
  }

  void handleExtractionResult(SymbolsOrError &Symbols) {
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
    } else {
      handleSymbols(Symbols.get());
    }
  }

};

int SymbolsWalkerAndCollector::SymbolIndex;

std::set<IndexedSymbolWithRange, IndexedSymbolWithRange::SymbolWithRangeCompare>
walkAndCollectSymbols(SourceFile &SourceFile, std::set<Excluder*> &Excluders) {
  SymbolsWalkerAndCollector Walker(Excluders);
  Walker.walk(SourceFile);
  for(auto Excluder: Excluders) {
    Excluder->excludeSymbolsFrom(Walker.Symbols);
  }
  return Walker.Symbols;
}

} //namespace obfuscation
} //namespace swift
