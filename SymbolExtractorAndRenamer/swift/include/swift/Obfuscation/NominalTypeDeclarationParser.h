#ifndef NominalTypeDeclarationParser_h
#define NominalTypeDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

namespace swift {
namespace obfuscation {
  
SingleSymbolOrError parse(const NominalTypeDecl* Declaration);

} //namespace obfuscation
} //namespace swift

#endif /* NominalTypeDeclarationParser_h */
