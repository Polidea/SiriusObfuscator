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
  
SymbolsOrError
parseSeparateFunctionDeclarationForParameters(const AbstractFunctionDecl* Declaration);
  
SymbolsOrError
parseFunctionFromCallExpressionForParameters(const FuncDecl* Declaration);

SingleSymbolOrError
symbolFromMemberwiseConstructorParameter(const ParamDecl* Parameter);
  
SymbolsOrError parseSeparateDeclarationWithRange(const ParamDecl* Declaration,
                                                 CharSourceRange Range);

SymbolsOrError parse(const ParamDecl* Declaration);

llvm::Expected<SymbolWithRange> buildSymbol(Identifier Name,
                                            ValueDecl *Decl,
                                            CharSourceRange Range);

  
} //namespace obfuscation
} //namespace swift

#endif /* ParameterDeclarationParser_h */
