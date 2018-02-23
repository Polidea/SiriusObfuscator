#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

llvm::Error stringError(const std::string Message,
                        const std::error_code Error) {
  return llvm::make_error<llvm::StringError>(Message, Error);
}

std::vector<std::string> split(const std::string &String, char Delimiter) {
  std::vector<std::string> SplittedElements;
  
  std::stringstream StringStream(String);
  std::string Item;
  while (std::getline(StringStream, Item, Delimiter)) {
    SplittedElements.push_back(Item);
  }
  
  return SplittedElements;
}
  
} //namespace obfuscation
} //namespace swift
