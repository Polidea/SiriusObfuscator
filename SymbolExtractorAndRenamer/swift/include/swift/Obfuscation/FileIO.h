#ifndef FileIO_h
#define FileIO_h

#include "llvm/Support/Error.h"
#include "llvm/Support/MemoryBuffer.h"

#include <string>

namespace swift {
namespace obfuscation {

/// Provides memory buffer for given path.
///
/// In case of failing during execution returns Error.
///
/// Typical usage:
/// \code
///  auto Buffer = BufferProvider.getBuffer(PathToJson);
/// \endcode
///
/// \param Path - string containing path to file.
///
/// \returns llvm::ErrorOr object containing either the memory buffer
/// or llvm::Error object with the information.
struct MemoryBufferProvider {
    virtual ~MemoryBufferProvider() = default;
    virtual llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>>
    getBuffer(std::string Path) const;
};

/// Provides file for given path.
///
/// In case of failing during execution returns Error.
///
/// Typical usage:
/// \code
/// auto File = Factory.getFile(PathToOutput);
/// \endcode
///
/// \param Path - string containing path to file.
///
/// \returns llvm::ErrorOr object containing either the file
/// or llvm::Error object with error information.
template <typename FileType>
struct FileFactory {
    virtual ~FileFactory() = default;
    virtual llvm::ErrorOr<std::unique_ptr<FileType>> getFile(std::string Path);
};

    
/// Given path to file containig json, parses file and returns object of type T.
///
/// In case of failing reading file or failing parsing json, returns Error.
///
/// Typical usage:
/// \code
/// auto FilesJsonOrError = parseJson<FilesJson>(PathToJson);
/// if (auto Error = FilesJsonOrError.takeError()) {
///    ExitOnError(std::move(Error));
/// }
/// \endcode
///
/// \param PathToJson - string containing path to file with json.
///
/// \param BufferProvider - optional parameter with object providing memory
/// buffer used during parsing.
///
/// \returns llvm::Expected object containing either the object of type T
/// read from file provided in \p PathToJson or llvm::Error object with
/// the information.
template<typename T>
llvm::Expected<T> parseJson(std::string PathToJson,
                            const MemoryBufferProvider &BufferProvider = MemoryBufferProvider());

} //namespace obfuscation
} //namespace swift

#include "FileIO-Template.h"

#endif /* FileIO_h */
