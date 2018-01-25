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
  
const FuncDecl*
baseOverridenDeclarationWithModules(const FuncDecl* Declaration,
                                    std::set<std::string> &Modules);
  
ModuleNameAndParts functionIdentifierParts(const FuncDecl* Declaration,
                                           const std::string &ModuleName,
                                           const std::string &SymbolName);
  
SymbolsOrError parse(const FuncDecl* Declaration, CharSourceRange Range);
    
} //namespace obfuscation
} //namespace swift

#endif /* FunctionDeclarationParser_h */
