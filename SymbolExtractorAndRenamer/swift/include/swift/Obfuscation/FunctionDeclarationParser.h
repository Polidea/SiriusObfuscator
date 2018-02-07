#ifndef FunctionDeclarationParser_h
#define FunctionDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include "llvm/Support/Error.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
    
std::string functionName(const FuncDecl* Declaration);
  
ModuleNameAndParts functionIdentifierParts(const FuncDecl *Declaration);
  
SymbolsOrError parse(const FuncDecl* Declaration, CharSourceRange Range);
    
} //namespace obfuscation
} //namespace swift

#endif /* FunctionDeclarationParser_h */
