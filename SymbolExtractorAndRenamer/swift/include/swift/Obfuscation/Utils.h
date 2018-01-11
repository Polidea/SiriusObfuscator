#ifndef Utils_h
#define Utils_h

#include "llvm/Support/Error.h"

#include <string>

namespace swift {
namespace obfuscation {

llvm::Error stringError(const std::string Message,
                        const std::error_code Error = std::error_code(1, std::generic_category()));

} //namespace obfuscation
} //namespace swift

#endif /* Utils_h */
