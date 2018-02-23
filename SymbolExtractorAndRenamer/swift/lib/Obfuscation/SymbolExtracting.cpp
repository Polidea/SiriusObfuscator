#include "swift/Obfuscation/SymbolExtracting.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/Utils.h"

#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

using FileWithName = std::pair<std::string, SourceFile *>;

// Creates a vector of parsed source files that is sorted alphabetically
// by the file name
std::vector<FileWithName>
getSortedSourceFiles(swift::CompilerInstance &CompilerInstance) {

  std::vector<FileWithName> Files;
  for (auto* Unit : CompilerInstance.getMainModule()->getFiles()) {
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
  
  CompilerInstance CompilerInstance;
  auto Error = setupCompilerInstance(CompilerInstance,
                                     FilesJson,
                                     MainExecutablePath,
                                     DiagnosticStream);
  if (Error) {
    return std::move(Error);
  }

  auto Files = getSortedSourceFiles(CompilerInstance);

  // This set is designed to treat all the occurences of symbol
  // (different ranges) as one symbol
  std::set<IndexedSymbolWithRange,
           IndexedSymbolWithRange::SymbolCompare> Symbols;

  for (auto &Unit : Files) {
    // CurrentSymbols are sorted by the identifier and range
    auto CurrentSymbols = walkAndCollectSymbols(*Unit.second);

    std::vector<IndexedSymbolWithRange> SortedSymbols;
    copyToVector(CurrentSymbols, SortedSymbols);

    // Sorting symbols by index
    std::sort(SortedSymbols.begin(),
              SortedSymbols.end(),
              [](const IndexedSymbolWithRange &Left,
                 const IndexedSymbolWithRange &Right) {
                return Left.Index < Right.Index;
              });

    // Inserting sorted symbols so that only the first occurrence's
    // index is present in the Symbols set. It ensures that
    // the order in which symbols occur is preserved
    copyToSet(SortedSymbols, Symbols);
  }

  std::vector<IndexedSymbolWithRange> Result;
  copyToVector(Symbols, Result);

  // This ensures that the alphabetical order of walking the source files
  // is preserved
  std::sort(Result.begin(),
            Result.end(),
            [](const IndexedSymbolWithRange &Left,
               const IndexedSymbolWithRange &Right) {
              return Left.Index < Right.Index;
            });

  SymbolsJson ResultingJson;

  // map: IndexedSymbolWithRange -> Symbol
  
  std::transform(Result.cbegin(),
                 Result.cend(),
                 std::back_inserter(ResultingJson.Symbols),
                 [](const IndexedSymbolWithRange &Symbol) -> struct Symbol {
                   return Symbol.SymbolWithRange.Symbol;
                 });

  return ResultingJson;
}

} //namespace obfuscation
} //namespace swift
