#ifndef VariableDeclarationParser_h
#define VariableDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

namespace swift {
namespace obfuscation {
    
SingleSymbolOrError parse(const VarDecl* Declaration);
    
} //namespace obfuscation
} //namespace swift


#endif /* VariableDeclarationParser_h */
