#ifndef NameMapping_h
#define NameMapping_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

namespace swift {
namespace obfuscation {

llvm::Expected<RenamesJson> proposeRenamings(const SymbolsJson &SymbolsJson);

} //namespace obfuscation

} //namespace swift

#endif /* NameMapping_h */
