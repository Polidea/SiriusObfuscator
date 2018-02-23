#ifndef SymbolExtracting_h
#define SymbolExtracting_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

#include <string>

namespace swift {
namespace obfuscation {

/// Performs the symbol extraction from the Swift source code files included
/// in the FilesJson structure.
///
/// It utilizes the Swift compiler to perform the semantic analysis of
/// the Swift source files. Using the information encoded in FilesJson,
/// it creates the compiler invocation for the files, then it asks for
/// semantic analysis, and then it uses the results of the analysis (AST tree)
/// to identify the symbols in the Swift source code that should be obfuscated.
///
/// It's designed to be called from the Swift compiler command line tool.
///
/// Typical usage:
/// \code
/// std::string MainExecutablePath = llvm::sys::fs::getMainExecutable(
///             argv[0], reinterpret_cast<void *>(&anchorForGetMainExecutable));
/// auto SymbolsOrError = extractSymbols(FilesJson,
///                                      MainExecutablePath,
///                                      DiagnosticStream);
/// \endcode
///
/// \param FilesJson It's the structure containing information necessary for
///        the compiler to perform analysis (such as list of Swift source
///        files, list of libraries to link, path to SDK containing
///        the system libraries etc.).
/// \param MainExecutablePath Path to the directory containing the tool calling
///        this function. This is required for the compiler to use the relative
///        paths for it's inner workings (such as finding the necessary
///        libraries to dynamically link).
/// \param DiagnosticStream Stream for writing the diagnostic information into.
///
/// \returns llvm::Expected object containing either the extracted symbols
///          in the SymbolJson structure or the llvm::Error object with
///          the information on the failure cause.
llvm::Expected<SymbolsJson> extractSymbols(const FilesJson &FilesJson,
                                           std::string MainExecutablePath,
                                           llvm::raw_ostream &DiagnosticStream);

} //namespace obfuscation
} //namespace swift

#endif /* SymbolExtracting_h */
