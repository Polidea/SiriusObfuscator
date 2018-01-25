#ifndef ExpressionParser_h
#define ExpressionParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/SourceFileWalker.h"

#include "llvm/Support/Error.h"

#include <vector>

namespace swift {
namespace obfuscation {

SymbolsOrError extractSymbol(Expr* Expression);
  
} //namespace obfuscation
} //namespace swift

#endif /* ExpressionParser_h */
