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

std::string combineIdentifier(std::vector<std::string> &Parts) {
  if (Parts.empty()) {
    return "";
  } else if (Parts.size() == 1) {
    return Parts[0];
  } else {
    //TODO: can we rewrite it to use llvm:raw_string_ostream?
    std::stringstream ResultStream;
    copyToStream(Parts, std::ostream_iterator<std::string>(ResultStream, "."));
    std::string Result = ResultStream.str();
    Result.pop_back();
    return Result;
  }
}
  
} //namespace obfuscation
} //namespace swift
