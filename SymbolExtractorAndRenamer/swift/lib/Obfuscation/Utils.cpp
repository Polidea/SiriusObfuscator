#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

llvm::Error stringError(const std::string Message,
                        const std::error_code Error) {
  return llvm::make_error<llvm::StringError>(Message, Error);
}

} //namespace obfuscation
} //namespace swift
