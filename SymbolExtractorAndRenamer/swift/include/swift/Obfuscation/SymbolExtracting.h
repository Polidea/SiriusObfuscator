#ifndef SymbolExtracting_h
#define SymbolExtracting_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

#include <string>

namespace swift {
namespace obfuscation {

llvm::Expected<SymbolsJson> extractSymbols(const FilesJson &FilesJson,
                                           std::string MainExecutablePath);

} //namespace obfuscation
} //namespace swift

#endif /* SymbolExtracting_h */
