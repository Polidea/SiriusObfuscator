#ifndef OperatorParser_h
#define OperatorParser_h

#include "swift/Obfuscation/DeclarationParsingUtils.h"

namespace swift {
namespace obfuscation {

/// Extract symbol from the declaration of the operator.
///
/// The declaration specifies only the name of the operator, its type
/// (prefix, infix, postfix) and its relation to other operators (precedence).
/// It's not the operator implementation nor usage.
///
/// \param Declaration The Swift AST OperatorDecl node that may represent
///        the symbol to obfuscate.
///
/// \returns SingleSymbolOrError object containing either the symbol extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SingleSymbolOrError parse(const OperatorDecl* Declaration);

/// Extracts symbol from the operator's implementation represented as FuncDecl
/// in the Swift AST.
///
/// The function declaration specifies the logic for the operator it implements.
/// We're parsing it in the similar manner as other functions, so both
/// the function symbol and the parameters symbols are identified.
///
/// \param Declaration The Swift AST node that may or may not represent
///        the symbol to obfuscate.
/// \param Range The range of the identifier in the source code
///        that corresponds with the encountered AST node.
///
/// \returns SymbolsOrError object containing either the symbol extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SymbolsOrError parseOperator(const FuncDecl* Declaration, CharSourceRange Range);

} //namespace obfuscation
} //namespace swift

#endif /* OperatorParser_h */
