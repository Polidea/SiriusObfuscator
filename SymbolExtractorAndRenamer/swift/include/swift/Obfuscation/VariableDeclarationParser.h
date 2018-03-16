#ifndef VariableDeclarationParser_h
#define VariableDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

namespace swift {
namespace obfuscation {

/// Extracts the symbol from the VarDecl AST node
///
/// In case no symbol is found, returnes Error.
///
/// \param Declaration The Swift AST node that may or may not represent
///        the symbol to obfuscate.
///
/// \returns llvm::Expected object containing either the symbol extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SingleSymbolOrError parse(const VarDecl* Declaration);
  
llvm::Expected<ModuleNameAndParts>
  variableIdentifierPartsFromContext(const VarDecl *Declaration);
} //namespace obfuscation
} //namespace swift


#endif /* VariableDeclarationParser_h */
