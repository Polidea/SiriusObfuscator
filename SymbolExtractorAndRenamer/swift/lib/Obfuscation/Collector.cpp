#include "swift/Obfuscation/Collector.h"

namespace swift {
namespace obfuscation {

Collector::Collector(std::unique_ptr<class Includer> Includer,
                     std::unique_ptr<class SymbolGenerator> SymbolGenerator)
: Includer(std::move(Includer)), SymbolGenerator(std::move(SymbolGenerator)) {}

std::vector<DeclWithSymbolWithRange>
Collector::collectFrom(DeclWithRange &DeclAndRange) {
  return collectFrom(std::move(DeclAndRange));
}

std::vector<DeclWithSymbolWithRange>
Collector::collectFrom(DeclWithRange &&DeclAndRange) {

  std::vector<DeclWithSymbolWithRange> Result;

  auto DeclWithRangesOrErrors = Includer->include(DeclAndRange);

  for (auto Iterator = DeclWithRangesOrErrors.begin();
       Iterator != DeclWithRangesOrErrors.end();
       ++Iterator) {

    if (auto Error = Iterator->takeError()) {
      llvm::consumeError(std::move(Error));
      continue;
    }
    auto DeclWithRange = Iterator->get();

    auto SymbolsOrErrors = SymbolGenerator->generateFor(DeclWithRange);

    for (auto Iterator = SymbolsOrErrors.begin();
         Iterator != SymbolsOrErrors.end();
         ++Iterator) {

      if (auto Error = Iterator->takeError()) {
        llvm::consumeError(std::move(Error));
        continue;
      }

      Result.push_back(Iterator->get());
    }
  }

  return Result;
}

} //namespace obfuscation
} //namespace swift

