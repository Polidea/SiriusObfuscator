#ifndef DeclarationParsingUtils_h
#define DeclarationParsingUtils_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
  
using ModuleNameAndParts = std::pair<std::string, std::vector<std::string>>;

std::string combineIdentifier(std::vector<std::string> &Parts);
  
std::string moduleName(const Decl* Declaration);
  
ModuleNameAndParts moduleNameAndParts(const Decl *Declaration);
  
std::string typeName(const NominalTypeDecl* Declaration);
  
llvm::Expected<std::string> enclosingTypeName(const Decl* Declaration);

} //namespace obfuscation
} //namespace swift
  
#endif /* DeclarationParsingUtils_h */
