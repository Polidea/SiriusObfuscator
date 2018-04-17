#include "swift/Obfuscation/SymbolsWalkerAndCollector.h"
#include "swift/Obfuscation/Utils-Template.h"
#include "swift/Obfuscation/Utils.h"

#include <string>

namespace swift {
namespace obfuscation {

// Overriden methods called back as the AST is walked

bool SymbolsWalkerAndCollector::walkToExprPre(Expr *Expression) {

  for (auto Iterator = Processors.cbegin();
       Iterator != Processors.cend();
       ++Iterator) {
    auto Declarations = Iterator->get()->declarationFrom(Expression);
    for (auto Iterator = Declarations.begin();
         Iterator != Declarations.end();
         ++Iterator) {
      auto DeclarationOrError = std::move(*Iterator);
      if (auto Error = DeclarationOrError.takeError()) {
        llvm::consumeError(std::move(Error));
      } else {
        handleDeclWithRange(DeclarationOrError.get());
      }
    }
  }

  return true;
}

void SymbolsWalkerAndCollector::
  identifyExcludedSymbols(DeclWithSymbolWithRange &DeclAndSymbolWithRange) {

  std::vector<DeclWithSymbolWithRange> SymbolsToExclude;

  for (auto Iterator = Excluders.cbegin();
       Iterator != Excluders.cend();
       ++Iterator) {
    auto SymbolToExclude =
      Iterator->get()->symbolsToExclude(DeclAndSymbolWithRange);
    if (SymbolToExclude != llvm::None) {
      SymbolsToExclude.push_back(SymbolToExclude.getValue());
    }
  }

  for (auto Iterator = Updaters.begin();
       Iterator != Updaters.end();
       ++Iterator) {
    if (Iterator->get()->getKind()
        == GlobalCollectedSymbolsUpdaterKind::ExcludedSymbols) {
      Iterator->get()->load(SymbolsToExclude);
    }
  }
}
  
void
SymbolsWalkerAndCollector::handleDeclWithRange(DeclWithRange &DeclWithRange) {
  for (auto Iterator = Collectors.begin();
       Iterator != Collectors.end();
       ++Iterator) {

    auto DeclsWithSymbolsWithRangesFromDeclaration =
    Iterator->get()->collectFrom(DeclWithRange);

    for (auto &DeclWithSymbolWithRange :
         DeclsWithSymbolsWithRangesFromDeclaration) {
      handleSymbol(DeclWithSymbolWithRange);

      identifyExcludedSymbols(DeclWithSymbolWithRange);

    }

    for (auto Iterator = Updaters.begin();
         Iterator != Updaters.end();
         ++Iterator) {
      if (Iterator->get()->getKind()
          != GlobalCollectedSymbolsUpdaterKind::ExcludedSymbols) {
        Iterator->get()->load(DeclsWithSymbolsWithRangesFromDeclaration);
      }
    }
  }
}

bool SymbolsWalkerAndCollector::walkToDeclPre(Decl *Declaration,
                                              CharSourceRange Range) {
  DeclWithRange DeclWithRange(Declaration, Range);
  handleDeclWithRange(DeclWithRange);
  return true;
}

void SymbolsWalkerAndCollector::
  handleWhereClausesIfNeeded(const std::vector<Decl*> &&Declarations) {
  for (auto *Declaration : Declarations) {
    for (auto Iterator = Processors.cbegin();
         Iterator != Processors.cend();
         ++Iterator) {
      auto Declarations = Iterator->get()->declarationFrom(Declaration);
      for (auto Iterator = Declarations.begin();
           Iterator != Declarations.end();
           ++Iterator) {
        auto DeclarationOrError = std::move(*Iterator);
        if (auto Error = DeclarationOrError.takeError()) {
          llvm::consumeError(std::move(Error));
        } else {
          handleDeclWithRange(DeclarationOrError.get());
        }
      }
    }
  }
}

// We need to extract symbols here even though we might have already seen
// this node in the walkToDeclPre because here we have additional
// contextual information like CtorTyRef
bool SymbolsWalkerAndCollector::visitDeclReference(ValueDecl *Declaration,
                                                   CharSourceRange Range,
                                                   TypeDecl *CtorTyRef,
                                                   ExtensionDecl *ExtTyRef,
                                                   Type T,
                                                   ReferenceMetaData Data) {

  auto DeclarationToUse = CtorTyRef ? CtorTyRef : Declaration;

  DeclWithRange DeclWithRangeToUse(DeclarationToUse, Range);
  handleDeclWithRange(DeclWithRangeToUse);

  DeclWithRange DeclWithRangeExtension(ExtTyRef, Range);
  handleDeclWithRange(DeclWithRangeExtension);

  handleWhereClausesIfNeeded({ Declaration, CtorTyRef, ExtTyRef });

  return true;
}

// Methods for handling the extracted symbols
  
void
SymbolsWalkerAndCollector::handleSymbol(const DeclWithSymbolWithRange &Symbol) {
  auto InsertionResult =
    Symbols.insert(IndexedDeclWithSymbolWithRange(SymbolIndex, Symbol));
  if (InsertionResult.second == true) {
    ++SymbolsWalkerAndCollector::SymbolIndex;
  }
}

GlobalCollectedSymbols SymbolsWalkerAndCollector::collectSymbols() {
  for (auto Iterator = Updaters.begin();
       Iterator != Updaters.end();
       ++Iterator) {
    Iterator->get()->updateUsingLoadedSymbols(Symbols);
  }
  return Symbols;
}

SymbolsWalkerAndCollector::
  SymbolsWalkerAndCollector(std::set<std::unique_ptr<Processor>> &Processors,
                            std::vector<std::unique_ptr<Collector>> &Collectors,
                            std::set<std::unique_ptr<Excluder>> &Excluders,
                            std::set<std::unique_ptr<GlobalCollectedSymbolsUpdater>> &Updaters)
: Processors(Processors),
  Collectors(Collectors),
  Excluders(Excluders),
  Updaters(Updaters)  {}

GlobalCollectedSymbols
SymbolsWalkerAndCollector::walkAndCollectSymbols(SourceFile &SourceFile) {
  walk(SourceFile);
  return collectSymbols();
}

int SymbolsWalkerAndCollector::SymbolIndex;

SymbolsWalkerAndCollectorFactory::SymbolsWalkerAndCollectorFactory() {

  FunctionExtractor FunctionExtractor;
  OperatorExtractor OperatorExtractor;
  ParameterExtractor ParameterExtractor;
  VariableExtractor VariableExtractor;
  TypeRepresentationExtractor TypeRepresentationExtractor;

  std::unique_ptr<Processor> ExpressionProcessor =
    llvm::make_unique<class ExpressionProcessor>(ParameterExtractor);
  Processors.insert(std::move(ExpressionProcessor));

  std::unique_ptr<Processor> WhereClauseProcessor =
    llvm::make_unique<class WhereClauseProcessor>(TypeRepresentationExtractor);
  Processors.insert(std::move(WhereClauseProcessor));

  std::unique_ptr<Includer> NominalTypeIncluder =
    llvm::make_unique<class NominalTypeIncluder>();
  std::unique_ptr<SymbolGenerator> NominalTypeSymbolGenerator =
    llvm::make_unique<class NominalTypeSymbolGenerator>(NominalTypeExtractor);
  auto NominalTypeCollector =
    llvm::make_unique<Collector>(std::move(NominalTypeIncluder),
                                 std::move(NominalTypeSymbolGenerator));
  Collectors.push_back(std::move(NominalTypeCollector));

  std::unique_ptr<Includer> FunctionNameIncluder =
    llvm::make_unique<class FunctionNameIncluder>();
  std::unique_ptr<SymbolGenerator> FunctionNameSymbolGenerator =
    llvm::make_unique<class FunctionNameSymbolGenerator>(FunctionExtractor);
  auto FunctionNameCollector =
    llvm::make_unique<Collector>(std::move(FunctionNameIncluder),
                                 std::move(FunctionNameSymbolGenerator));
  Collectors.push_back(std::move(FunctionNameCollector));

  std::unique_ptr<Includer> OperatorIncluder =
    llvm::make_unique<class OperatorIncluder>(OperatorExtractor);
  std::unique_ptr<SymbolGenerator> OperatorSymbolGenerator =
    llvm::make_unique<class OperatorSymbolGenerator>(OperatorExtractor);
  auto OperatorCollector =
    llvm::make_unique<Collector>(std::move(OperatorIncluder),
                                 std::move(OperatorSymbolGenerator));
  Collectors.push_back(std::move(OperatorCollector));

  std::unique_ptr<Includer> FunctionParametersIncluder =
    llvm::make_unique<class FunctionParametersIncluder>(ParameterExtractor);
  std::unique_ptr<SymbolGenerator> FunctionParameterSymbolGenerator =
    llvm::make_unique<class FunctionParameterSymbolGenerator>(FunctionExtractor,
                                                              ParameterExtractor);
  auto FunctionParameterCollector =
    llvm::make_unique<Collector>(std::move(FunctionParametersIncluder),
                                 std::move(FunctionParameterSymbolGenerator));
  Collectors.push_back(std::move(FunctionParameterCollector));

  std::unique_ptr<Includer> VariableIncluder =
    llvm::make_unique<class VariableIncluder>(VariableExtractor);
  std::unique_ptr<SymbolGenerator> VariableSymbolGenerator =
    llvm::make_unique<class VariableSymbolGenerator>(VariableExtractor);
  auto VariableCollector =
    llvm::make_unique<Collector>(std::move(VariableIncluder),
                                 std::move(VariableSymbolGenerator));
  Collectors.push_back(std::move(VariableCollector));

  std::unique_ptr<Excluder> NSManagedExcluder =
    llvm::make_unique<class NSManagedExcluder>();
  Excluders.insert(std::move(NSManagedExcluder));

  std::unique_ptr<GlobalCollectedSymbolsUpdater> ExcludedSymbolsUpdater =
    llvm::make_unique<class ExcludedSymbolsUpdater>();
  Updaters.insert(std::move(ExcludedSymbolsUpdater));

  std::unique_ptr<GlobalCollectedSymbolsUpdater> ProtocolFunctionUpdater =
    llvm::make_unique<class ProtocolFunctionUpdater>(FunctionExtractor,
                                                     ParameterExtractor);
  Updaters.insert(std::move(ProtocolFunctionUpdater));

  std::unique_ptr<GlobalCollectedSymbolsUpdater> ExtensionSymbolsUpdater =
    llvm::make_unique<class ExtensionSymbolsUpdater>(FunctionExtractor,
                                                     ParameterExtractor);
  Updaters.insert(std::move(ExtensionSymbolsUpdater));
}

SymbolsWalkerAndCollectorFactory::
  SymbolsWalkerAndCollectorFactory(ObfuscationConfiguration &&ObfuscationConfiguration)
: SymbolsWalkerAndCollectorFactory() {
  std::unique_ptr<Excluder> Configuration =
  llvm::make_unique<ConfigurationExcluder>(std::move(ObfuscationConfiguration),
                                           NominalTypeExtractor);
  Excluders.insert(std::move(Configuration));
}

SymbolsWalkerAndCollector SymbolsWalkerAndCollectorFactory::
  symbolsWalkerAndCollector() {
  return SymbolsWalkerAndCollector(Processors,
                                   Collectors,
                                   Excluders,
                                   Updaters);
}

} //namespace obfuscation
} //namespace swift
