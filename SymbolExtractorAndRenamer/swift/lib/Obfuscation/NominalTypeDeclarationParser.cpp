#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

SingleSymbolOrError parse(const NominalTypeDecl* Declaration) {

  auto ModuleNameAndParts = moduleNameAndIdentifierParts(Declaration);

  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> IdentifierParts = ModuleNameAndParts.second;
  std::string SymbolName = Declaration->getBaseName().getIdentifier().str();
  
  auto NominalTypeParts = nominalTypeIdentifierParts(Declaration,
                                                     typeName(Declaration));
  if (auto Error = NominalTypeParts.takeError()) {
    return std::move(Error);
  }
  copyToVector(NominalTypeParts.get(), IdentifierParts);
  
  return Symbol(combineIdentifier(IdentifierParts),
                SymbolName,
                ModuleName,
                SymbolType::Type);
}

} //namespace obfuscation
} //namespace swift
