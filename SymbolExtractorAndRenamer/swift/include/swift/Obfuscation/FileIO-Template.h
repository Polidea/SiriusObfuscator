#ifndef FileIOTemplate_h
#define FileIOTemplate_h

#include "llvm/Support/Error.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/FileSystem.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Utils.h"

#include <string>

namespace swift {
namespace obfuscation {

template<class FileType>
llvm::ErrorOr<std::unique_ptr<FileType>>
FileFactory<FileType>::getFile(std::string Path) {
  std::error_code Error;
  auto File = llvm::make_unique<FileType>(Path, Error, llvm::sys::fs::F_None);
  if (Error) {
      return Error;
  }

  return File;
}

template<class T, typename FileType>
llvm::Error writeToPath(T &Object,
                        std::string PathToOutput,
                        FileFactory<FileType> Factory,
                        llvm::raw_ostream &LogStream) {

  std::error_code Error;
  auto File = Factory.getFile(PathToOutput);
  if (auto FileError = File.getError()) {
      return stringError("Failed to open file: " + PathToOutput, FileError);
  }

  return writeToFile(Object, LogStream, std::move(File.get()));
}

template<typename T, typename FileType>
llvm::Error writeToFile(T &Object,
                        llvm::raw_ostream &LogStream,
                        std::unique_ptr<FileType> File) {

  auto SerializedObject = json::serialize(Object);
  *File << SerializedObject;
  File->close();

  LogStream << "Written to file: " << '\n'
            << SerializedObject << '\n';

  return llvm::Error::success();
}

} //namespace obfuscation
} //namespace swift

#endif /* FileIOTemplate_h */
