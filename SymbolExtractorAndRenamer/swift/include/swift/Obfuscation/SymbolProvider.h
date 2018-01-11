#ifndef SymbolProvider_h
#define SymbolProvider_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

#include <set>

namespace swift {
namespace obfuscation {

struct SymbolWithRange {
  Symbol Symbol;
  CharSourceRange Range;
  
  SymbolWithRange(const swift::obfuscation::Symbol &Symbol,
                  const CharSourceRange &Range)
  : Symbol(Symbol), Range(Range) {}
  
  bool operator< (const SymbolWithRange &Right) const;
};

std::set<SymbolWithRange> findSymbolsWithRanges(SourceFile &SourceFile);

} //namespace obfuscation
} //namespace swift

#endif /* SymbolProvider_h */
