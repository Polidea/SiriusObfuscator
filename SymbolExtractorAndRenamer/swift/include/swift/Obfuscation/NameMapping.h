#ifndef NameMapping_h
#define NameMapping_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

namespace swift {
namespace obfuscation {
  
/// Creates renamings for symbols found in SymbolsJson object.
///
/// Rename generation depends on the type of the symbol found in SymbolsJson.
/// Proposed new name for specific type must conform to [Swift Grammar]
/// (https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html).
/// Generated names are unique to ensure that no symbol name collisions will
/// occur after renaming.
///
/// Typical usage:
/// \code
/// auto RenamingsOrError = proposeRenamings(SymbolsJson);
/// if (auto Error = RenamingsOrError.takeError()) {
///   ExitOnError(std::move(Error));
/// }
/// auto Renamings = RenamingsOrError.get();
/// \endcode
///
/// \param SymbolsJson Symbols before renaming
///
/// \returns Symbols with proposed renamings or error.
/// Each SymbolRenaming object contains data of the symbol before renaming
/// and proposed new name.
llvm::Expected<RenamesJson> proposeRenamings(const SymbolsJson &SymbolsJson);

} //namespace obfuscation

} //namespace swift

#endif /* NameMapping_h */
