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
  
ModuleNameAndParts moduleNameAndParts(const Decl *Declaration);
  
std::string typeName(const NominalTypeDecl* Declaration);


llvm::Expected<std::string> enclosingTypeName(const Decl* Declaration);

template<class T>
const T* baseOverridenDeclarationWithModules(const T *Declaration,
                                            std::set<std::string> &Modules);

} //namespace obfuscation
} //namespace swift
  
#endif /* DeclarationParsingUtils_h */
