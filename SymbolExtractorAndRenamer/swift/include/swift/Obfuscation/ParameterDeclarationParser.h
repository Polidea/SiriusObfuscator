#ifndef ParameterDeclarationParser_h
#define ParameterDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include "llvm/Support/Error.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
  
SymbolsOrError
parseSeparateFunctionDeclarationForParameters(const FuncDecl* Declaration);

SymbolsOrError
parseFunctionFromCallExpressionForParameters(const FuncDecl* Declaration);
  
SymbolsOrError parseSeparateDeclarationWithRange(const ParamDecl* Declaration,
                                                 CharSourceRange Range);
  
} //namespace obfuscation
} //namespace swift

#endif /* ParameterDeclarationParser_h */
