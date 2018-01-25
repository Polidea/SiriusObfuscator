#include "swift/Obfuscation/FileIO.h"
#include "swift/Obfuscation/Utils.h"

#include "llvm/Support/FileSystem.h"
#include "llvm/Support/YAMLParser.h"
#include "swift/Basic/JSONSerialization.h"

namespace swift {
namespace obfuscation {

llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>
MemoryBufferProvider::getBuffer(std::string Path) const {
    return llvm::MemoryBuffer::getFile(Path);
}

template<class T>
llvm::Expected<T> parseJson(std::string PathToJson,
                            const MemoryBufferProvider &BufferProvider) {

  auto Buffer = BufferProvider.getBuffer(PathToJson);
  if (auto ErrorCode = Buffer.getError()) {
    return stringError("Error during JSON file read", ErrorCode);
  }
  
  return llvm::yaml::deserialize<T>(std::move(Buffer.get())->getBuffer());
}

template
llvm::Expected<FilesJson>
parseJson(std::string,
          const MemoryBufferProvider &BufferProvider = MemoryBufferProvider());

template
llvm::Expected<SymbolsJson>
parseJson(std::string,
          const MemoryBufferProvider &BufferProvider = MemoryBufferProvider());

template
llvm::Expected<RenamesJson>
parseJson(std::string,
          const MemoryBufferProvider &BufferProvider = MemoryBufferProvider());

} //namespace obfuscation
} //namespace swift
