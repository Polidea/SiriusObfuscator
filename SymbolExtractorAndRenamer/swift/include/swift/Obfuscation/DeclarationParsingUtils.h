#ifndef DeclarationParsingUtils_h
#define DeclarationParsingUtils_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
  
using ModuleNameAndParts = std::pair<std::string, std::vector<std::string>>;
  
std::string combineIdentifier(std::vector<std::string> &Parts);

std::string declarationName(const ValueDecl* Declaration);

std::string moduleName(const Decl* Declaration);

std::string externalParameterName(const ParamDecl *Declaration);

std::string internalParameterName(const ParamDecl *Declaration);

std::string symbolName(const OperatorDecl *Declaration);

std::string functionName(const AbstractFunctionDecl* Declaration);

llvm::Expected<std::vector<std::string>>
nominalTypeIdentifierParts(const NominalTypeDecl *Declaration,
                           const std::string &SymbolName);
  
ModuleNameAndParts moduleNameAndIdentifierParts(const Decl *Declaration);
  
std::string typeName(const NominalTypeDecl* Declaration);


llvm::Expected<std::string> enclosingTypeName(const Decl* Declaration);

template<class T>
std::pair<const T*, std::set<std::string>>
getBaseOverridenDeclarationWithModules(const T *Declaration);

bool isMemberwise(const ConstructorDecl* Declaration);

bool isMemberwiseConstructorParameter(const ParamDecl* Declaration);

} //namespace obfuscation
} //namespace swift
  
#endif /* DeclarationParsingUtils_h */
