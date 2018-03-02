#ifndef WhereClauseParser_h
#define WhereClauseParser_h

#include "swift/Obfuscation/DataStructures.h"

#include "swift/AST/Decl.h"

#include <set>

namespace swift {
namespace obfuscation {

class WhereClauseParser {

private:

  std::set<SymbolWithRange> Symbols;

public:

  void collectSymbolsFromDeclaration(Decl* Declaration);

  std::set<SymbolWithRange> harvestSymbols();

private:

  void handleWhereClause(TrailingWhereClause *WhereClause);

};

} //namespace obfuscation
} //namespace swift

#endif /* WhereClauseParser_h */
