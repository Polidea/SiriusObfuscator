#include "swift/Obfuscation/FileIO.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Utils.h"

#include "llvm/Support/FileSystem.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/YAMLParser.h"
#include "swift/Basic/JSONSerialization.h"

namespace swift {
namespace obfuscation {

template<class T>
llvm::Expected<T> parseJson(std::string PathToJson) {
  auto Buffer = llvm::MemoryBuffer::getFile(PathToJson);
  if (auto ErrorCode = Buffer.getError()) {
    return stringError("Error during JSON file read", ErrorCode);
  }
  
  llvm::yaml::Input Input(std::move(Buffer.get())->getBuffer());
  T Json;
  Input >> Json;
  if (auto ErrorCode = Input.error()) {
    return stringError("Error during JSON parse", ErrorCode);
  }
  
  return Json;
}

template llvm::Expected<FilesJson> parseJson(std::string);

template llvm::Expected<SymbolsJson> parseJson(std::string);

template llvm::Expected<RenamesJson> parseJson(std::string);

template<class T>
llvm::Error writeToFile(T &Object,
                        std::string PathToOutput,
                        llvm::raw_ostream &LogStream) {
  
  std::string OutputString;
  llvm::raw_string_ostream OutputStringStream(OutputString);
  swift::json::Output Output(OutputStringStream);
  Output << Object;
  // TODO: add serialization error handling
  
  std::error_code Error;
  llvm::raw_fd_ostream File(PathToOutput, Error, llvm::sys::fs::F_None);
  if (File.has_error() || Error) {
    return stringError("Failed to open file: " + PathToOutput, Error);
  }
  File << OutputStringStream.str();
  File.close();
  
  LogStream << "Written to file: " << '\n'
    << OutputStringStream.str() << '\n';
  
  return llvm::Error::success();
}

template llvm::Error writeToFile(SymbolsJson &,
                                 std::string,
                                 llvm::raw_ostream &);

template llvm::Error writeToFile(RenamesJson &,
                                 std::string,
                                 llvm::raw_ostream &);

} //namespace obfuscation
} //namespace swift
