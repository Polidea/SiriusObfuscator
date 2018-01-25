#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"

#include <sstream>
#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

std::string combineIdentifier(std::vector<std::string> &Parts) {
  if (Parts.empty()) {
    return "";
  } else if (Parts.size() == 1) {
    return Parts[0];
  } else {
    //TODO: can we rewrite it to use llvm:raw_string_ostream?
    std::stringstream ResultStream;
    copyToStream(Parts, std::ostream_iterator<std::string>(ResultStream, "."));
    std::string Result = ResultStream.str();
    Result.pop_back();
    return Result;
  }
}

std::string moduleName(const Decl* Declaration) {
  return Declaration->getModuleContext()->getBaseName().getIdentifier().get();
}

ModuleNameAndParts moduleNameAndParts(const Decl *Declaration) {
  std::vector<std::string> Parts;
  std::string ModuleName = moduleName(Declaration);
  Parts.push_back("module");
  Parts.push_back(ModuleName);
  return std::make_pair(ModuleName, Parts);
}

std::string typeName(const NominalTypeDecl* Declaration) {
  return Declaration->getDeclaredInterfaceType()->getString();
}

llvm::Expected<std::string> enclosingTypeName(const Decl* Declaration) {
  auto *DeclarationContext = Declaration->getDeclContext();
  if (auto *TypeDeclaration =
      DeclarationContext->getAsNominalTypeOrNominalTypeExtensionContext()) {
    return typeName(TypeDeclaration);
  }
  return stringError("enclosing context of this declaration is not supported");
}
  
} //namespace obfuscation
} //namespace swift

