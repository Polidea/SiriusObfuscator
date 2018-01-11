#ifndef FileIO_h
#define FileIO_h

#include "llvm/Support/Error.h"

#include <string>

namespace swift {
namespace obfuscation {

template<typename T>
llvm::Expected<T> parseJson(std::string PathToJson);

template<typename T>
llvm::Error writeToFile(T &Object,
                        std::string PathToOutput,
                        llvm::raw_ostream &LogStream);

} //namespace obfuscation
} //namespace swift

#endif /* FileIO_h */
