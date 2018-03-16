#include "swift/Obfuscation/Excluder.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParser.h"

namespace swift {
namespace obfuscation {
  
void Excluder::
excludeSymbolsFrom(GlobalCollectedSymbols &CollectedSymbols) {
  
  std::vector<IndexedSymbolWithRange> SymbolsToRemove;
  
  for (auto *Declaration : DeclarationsToExclude) {
    
    auto Range = CharSourceRange();
    auto SymbolsOrError = extractSymbol(CollectedSymbols, Declaration, Range);
    if (auto Error = SymbolsOrError.takeError()) {
      llvm::consumeError(std::move(Error));
    } else {
      auto Symbols = SymbolsOrError.get();
      for (auto CollectedSymbol : CollectedSymbols) {
        for (auto Symbol : Symbols) {
          if(CollectedSymbol.SymbolWithRange.Symbol.Identifier
             == Symbol.Symbol.Identifier) {
            SymbolsToRemove.push_back(CollectedSymbol);
          }
        }
      }
    }
  }
  
  for (auto IndexedSymbolWithRange : SymbolsToRemove) {
    CollectedSymbols.erase(IndexedSymbolWithRange);
  }
}
  
} //namespace obfuscation
} //namespace swift

