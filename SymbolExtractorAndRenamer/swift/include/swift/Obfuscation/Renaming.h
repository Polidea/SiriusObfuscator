#ifndef Renaming_h
#define Renaming_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

#include <vector>
#include <string>
#include <utility>

namespace swift {
namespace obfuscation {

using FilesList = std::vector<std::pair<std::string, std::string>>;
  
/// Creates project copy in ObfuscatedProjectPath and performs symbol renaming
/// defined in RenamesJson in the following steps:
///
/// 1. Performs semantic analysis of the project files defined in FilesJson and
/// creates AST. All input project files have to be in
/// FilesJson.Project.RootPath or subdirectories.
/// 2. Copies all project files to ObfuscatedProjectPath.
/// 3. Walks the AST and collects symbols listed in RenamesJson.
/// 4. Performs renames on collected symbols in project copy
/// in ObfuscatedProjectPath using renames from RenamesJson.
/// 5. Performs renames on layout files (.storyboard and .xib)
/// using paths from FilesJson. More information about layouts
/// renaming in LayoutRenamer.h.
///
/// Typical usage:
/// \code
/// auto FilesOrError = performRenaming(MainExecutablePath,
///   FilesJson,
///   RenamesJson,
///   ObfuscatedProjectPath);
/// if (auto Error = FilesOrError.takeError()) {
///   ExitOnError(std::move(Error));
/// }
/// auto ObfuscatedFiles = FilesOrError.get()
/// \endcode
///
/// \param MainExecutablePath Path of the executable that invokes the semantic
/// analysis. It is passed to CompilerInvocation object during Compiler setup.
/// \param FilesJson Object containing unobfuscated project root path,
/// and data required by CompilerInstance to perform semantic analysis,
/// such as module name, input filenames, framework search paths and SDK path.
/// \param RenamesJson Symbols to be renamed. Each SymbolRenaming object
/// contains the new name.
/// \param ObfuscatedProjectPath Path where the project copy will be created
/// and renaming will be performed.
/// \param DiagnosticStream Stream for writing the diagnostic information into.
///
/// \returns List of project files that were affected by the renaming.
llvm::Expected<FilesList>
performRenaming(std::string MainExecutablePath,
                const FilesJson &FilesJson,
                ObfuscationConfiguration &&ObfuscationConfiguration,
                const RenamesJson &RenamesJson,
                std::string ObfuscatedProjectPath,
                llvm::raw_ostream &DiagnosticStream);

} //namespace obfuscation
} //namespace swift

#endif /* Renaming_h */
