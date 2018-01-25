#include "swift/Obfuscation/SymbolExtracting.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/CompilerInfrastructure.h"
#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/Utils.h"

#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

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
  std::set<Symbol> Result;
  for (auto* Unit : CompilerInstance.getMainModule()->getFiles()) {
    if (auto* Current = dyn_cast<SourceFile>(Unit)) {
      auto CurrentSymbols = walkAndCollectSymbols(*Current);
      for (const auto &Symbol : CurrentSymbols) {
        Result.insert(Symbol.Symbol);
      }
    }
  }
  copyToVector(Result, Json.Symbols);
  return Json;
}

} //namespace obfuscation
} //namespace swift
