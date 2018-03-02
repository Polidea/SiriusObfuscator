#ifndef ParameterDeclarationParser_h
#define ParameterDeclarationParser_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include "llvm/Support/Error.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

/// Extracts the parameters' symbols from the function declaration
/// that defines them.
///
/// \param Declaration The Swift AST AbstractFunctionDecl corresponding with
///        the function declaration that we want to extract the parameters of.
///
/// \returns SymbolsOrError object containing either the symbols extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SymbolsOrError
parseSeparateFunctionDeclarationForParameters(const AbstractFunctionDecl* Declaration);

/// Extracts the parameters' symbols from the function call
/// that references them when passing values as arguments.
///
/// \param Declaration The Swift AST AbstractFunctionDecl corresponding with
///        the declaration of the function that is being called with parameters.
///
/// \returns SymbolsOrError object containing either the symbols extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SymbolsOrError
parseFunctionFromCallExpressionForParameters(const AbstractFunctionDecl* Declaration);

/// Parses the usage of parameter in the body of the function that declares it.
///
/// \param Declaration The Swift AST ParamDecl corresponding with
///        the parameter that is referenced when used in the function body.
///
/// \param Range The place in which the parameter is being used
///        in the function body.
///
/// \returns SymbolsOrError object containing either the symbols extracted
///          from information in \p Declaration object or llvm::Error object
///          with the information on why no symbol could be extracted.
SymbolsOrError parseSeparateDeclarationWithRange(const ParamDecl* Declaration,
                                                 CharSourceRange Range);

} //namespace obfuscation
} //namespace swift

#endif /* ParameterDeclarationParser_h */
