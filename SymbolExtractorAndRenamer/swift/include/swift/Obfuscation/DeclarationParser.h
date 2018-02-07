#ifndef DeclarationParser_h
#define DeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/SourceFileWalker.h"

namespace swift {
namespace obfuscation {
  
/// Given the Swift AST node of Decl type, identifies the symbol it represents.
///
/// In case no symbol is found, returnes Error.
///
/// Only a subset of all the possible Decl is of interest to obfuscation.
/// Therefore the user of this function should expect to often receive
/// the error output and be ready to handle it gracefully.
///
/// Typical usage:
/// \code
/// auto SymbolOrError = extractSymbol(Declaration);
/// if (auto Error = SymbolOrError.takeError()) {
///   llvm::consumeError(std::move(Error));
///   return true;
/// }
/// \endcode
///
/// \param Declaration The Swift AST node that may or may not represent
///        the symbol to obfuscate.
///
/// \returns llvm::Expected object containing either the symbol extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SymbolsOrError
extractSymbol(Decl* Declaration, CharSourceRange Range);
    
} //namespace obfuscation
} //namespace swift

#endif /* DeclarationParser_h */
