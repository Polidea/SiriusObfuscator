#ifndef SourceFileWalker_h
#define SourceFileWalker_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Collector.h"
#include "swift/Obfuscation/Excluder.h"
#include "swift/Obfuscation/GlobalCollectedSymbolsUpdater.h"
#include "swift/Obfuscation/Processor.h"

#include <set>

namespace swift {
namespace obfuscation {

class SymbolsWalkerAndCollector : public SourceEntityWalker {

private:

  static int SymbolIndex;

  GlobalCollectedSymbols Symbols;

  std::set<std::unique_ptr<Processor>> &Processors;
  std::vector<std::unique_ptr<Collector>> &Collectors;
  std::set<std::unique_ptr<Excluder>> &Excluders;
  std::set<std::unique_ptr<GlobalCollectedSymbolsUpdater>> &Updaters;

  bool walkToExprPre(Expr *) override;

  void identifyExcludedSymbols(DeclWithSymbolWithRange &);

  void handleDeclWithRange(DeclWithRange &);

  bool walkToDeclPre(Decl *, CharSourceRange) override;

  void handleWhereClausesIfNeeded(const std::vector<Decl*> &&);

  bool visitDeclReference(ValueDecl *,
                          CharSourceRange,
                          TypeDecl *,
                          ExtensionDecl *,
                          Type,
                          ReferenceMetaData) override;

  void handleSymbol(const DeclWithSymbolWithRange &);

  GlobalCollectedSymbols collectSymbols();

protected:

  SymbolsWalkerAndCollector(std::set<std::unique_ptr<Processor>> &,
                            std::vector<std::unique_ptr<Collector>> &,
                            std::set<std::unique_ptr<Excluder>> &,
                            std::set<std::unique_ptr<GlobalCollectedSymbolsUpdater>> &);

friend class SymbolsWalkerAndCollectorFactory;

public:

  GlobalCollectedSymbols walkAndCollectSymbols(SourceFile &SourceFile);

};

class SymbolsWalkerAndCollectorFactory {

private:

  std::set<std::unique_ptr<Processor>> Processors;
  std::vector<std::unique_ptr<Collector>> Collectors;
  NominalTypeExtractor NominalTypeExtractor;
  std::set<std::unique_ptr<Excluder>> Excluders;
  std::set<std::unique_ptr<GlobalCollectedSymbolsUpdater>> Updaters;

public:

  SymbolsWalkerAndCollectorFactory();

  SymbolsWalkerAndCollectorFactory(ObfuscationConfiguration &&);

  SymbolsWalkerAndCollector symbolsWalkerAndCollector();

};

} //namespace obfuscation
} //namespace swift

#endif /* SourceFileWalker_h */
