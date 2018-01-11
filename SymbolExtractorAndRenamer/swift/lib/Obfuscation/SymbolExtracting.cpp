#include "swift/Obfuscation/SymbolExtracting.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/SymbolProvider.h"

#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

std::set<Symbol> findSymbolsToObfuscate(SourceFile &SourceFile) {
  auto Source = findSymbolsWithRanges(SourceFile);
  std::set<Symbol> Result;
  for (const auto &Symbol : Source) {
    Result.insert(Symbol.Symbol);
  }
  return Result;
}

llvm::Expected<SymbolsJson> extractSymbols(const FilesJson &FilesJson,
                                          std::string MainExecutablePath) {
  
  CompilerInstance CompilerInstance;
  auto Error = setupCompilerInstance(CompilerInstance,
                                     FilesJson,
                                     MainExecutablePath);
  if (Error) {
    return std::move(Error);
  }
  
  SymbolsJson Json;
  for (auto* Unit : CompilerInstance.getMainModule()->getFiles()) {
    if (auto* Current = dyn_cast<SourceFile>(Unit)) {
      auto CurrentSymbols = findSymbolsToObfuscate(*Current);
      std::copy(CurrentSymbols.begin(),
                CurrentSymbols.end(),
                std::back_inserter(Json.Symbols));
    }
  }
  return Json;
}

} //namespace obfuscation
} //namespace swift
