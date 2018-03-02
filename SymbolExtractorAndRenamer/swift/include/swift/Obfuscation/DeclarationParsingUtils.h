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

/// Checks that all the overridden functions in the override list are
/// from the same module and this module is the module of originally parsed
/// function.
///
/// \param Modules The list of modules that the overridden functions
///        are defined in.
///
/// \param OriginModuleName The name of the module that
///        the originally parsed function is defined in.
///
/// \returns true if all overridden functions are from the same module of
///          the parsed function, and false otherwise.
bool isOverriddenMethodFromTheSameModule(const std::set<std::string> &Modules,
                                         const std::string &OriginModuleName);

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

llvm::Expected<CharSourceRange>
rangeOfFirstOccurenceOfStringInSourceLoc(std::string String,
                                         SourceLoc StartSourceLoc);
  
} //namespace obfuscation
} //namespace swift
  
#endif /* DeclarationParsingUtils_h */
