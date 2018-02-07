#ifndef CompilerInfrastructure_h
#define CompilerInfrastructure_h

#include "llvm/Support/Error.h"
#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

#include <string>

namespace swift {
namespace obfuscation {

/// Will setup provided CompilerInstance with configuration generated using
/// FileJson and MainExecutablePath. If setup succeeds it parses and
/// type-checks all files provided during configuration.
///
/// In case of failing during instance setup returns Error.
///
/// Typical usage:
/// \code
/// auto FilesJsonOrError = parseJson<FilesJson>(PathToJson);
/// if (auto Error = setupCompilerInstance(CI, FilesJson, MainExecutablePath)) {
///   return std::move(Error);
/// }
/// \endcode
///
/// \param CompilerInstance - compiler instance to setup.
///
/// \param MainExecutablePath - string containing path to main executable used
/// during compiler isntance 
///
/// \returns llvm::Error::success when setup finished correctly or
/// error object describing cause of fail.
llvm::Error
setupCompilerInstance(CompilerInstance &CompilerInstance,
                      const FilesJson &FilesJson,
                      std::string MainExecutablePath,
                      llvm::raw_ostream &LogStream);
  
} //namespace obfuscation
} //namespace swift

#endif /* CompilerInfrastructure_h */
