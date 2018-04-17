#include "swift/Obfuscation/SymbolExtracting.h"
#include "swift/Obfuscation/Collector.h"
#include "swift/Obfuscation/Includer.h"
#include "swift/Obfuscation/SymbolGenerator.h"
#include "swift/Obfuscation/Extractor.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/SymbolsWalkerAndCollector.h"
#include "swift/Obfuscation/GlobalCollectedSymbolsUpdater.h"
#include "swift/Obfuscation/Utils.h"

#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

using FileWithName = std::pair<std::string, SourceFile *>;

// Creates a vector of parsed source files that is sorted alphabetically
// by the file name
std::vector<FileWithName>
getSortedSourceFiles(std::unique_ptr<CompilerInstance> &CompilerInstance) {

  std::vector<FileWithName> Files;
  for (auto* Unit : CompilerInstance->getMainModule()->getFiles()) {
    if (auto* Current = dyn_cast<SourceFile>(Unit)) {
      Files.push_back(std::make_pair(Current->getFilename().str(), Current));
    }
  }

  std::sort(Files.begin(),
            Files.end(),
            [](const FileWithName &Left, const FileWithName &Right) {
              return Left.first < Right.first;
            });

  return Files;
}

llvm::Expected<SymbolsJson>
extractSymbols(const FilesJson &FilesJson,
               std::string MainExecutablePath,
               llvm::raw_ostream &DiagnosticStream) {
  
  auto CompilerInstanceOrError = createCompilerInstance(FilesJson,
                                                        MainExecutablePath,
                                                        DiagnosticStream);
  if (auto Error = CompilerInstanceOrError.takeError()) {
    return std::move(Error);
  }

  auto CompilerInstance = std::move(CompilerInstanceOrError.get());
  auto Files = getSortedSourceFiles(CompilerInstance);

  // This set is designed to treat all the occurences of symbol
  // (different ranges) as one symbol
  std::set<IndexedDeclWithSymbolWithRange,
           IndexedDeclWithSymbolWithRange::SymbolCompare> Symbols;

  SymbolsWalkerAndCollectorFactory Factory;

  for (auto &Unit : Files) {
    // CurrentSymbols are sorted by the identifier and range

    auto Collector = Factory.symbolsWalkerAndCollector();
    auto CurrentSymbols = Collector.walkAndCollectSymbols(*Unit.second);

    std::vector<IndexedDeclWithSymbolWithRange> SortedSymbols;
    copyToVector(CurrentSymbols, SortedSymbols);

    // Sorting symbols by index
    std::sort(SortedSymbols.begin(),
              SortedSymbols.end(),
              [](const IndexedDeclWithSymbolWithRange &Left,
                 const IndexedDeclWithSymbolWithRange &Right) {
                return Left.Index < Right.Index;
              });

    // Inserting sorted symbols so that only the first occurrence's
    // index is present in the Symbols set. It ensures that
    // the order in which symbols occur is preserved
    copyToSet(SortedSymbols, Symbols);
  }

  std::vector<IndexedDeclWithSymbolWithRange> Result;
  copyToVector(Symbols, Result);

  // This ensures that the alphabetical order of walking the source files
  // is preserved
  std::sort(Result.begin(),
            Result.end(),
            [](const IndexedDeclWithSymbolWithRange &Left,
               const IndexedDeclWithSymbolWithRange &Right) {
              return Left.Index < Right.Index;
            });

  SymbolsJson ResultingJson;

  // map: IndexedSymbolWithRange -> Symbol
  
  std::transform(Result.cbegin(),
                 Result.cend(),
                 std::back_inserter(ResultingJson.Symbols),
                 [](const IndexedDeclWithSymbolWithRange &Symbol) -> struct Symbol {
                   return Symbol.Symbol;
                 });

  return ResultingJson;
}

} //namespace obfuscation
} //namespace swift
