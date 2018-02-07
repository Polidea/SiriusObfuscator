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

std::string declarationName(const ValueDecl* Declaration) {
  return Declaration->getName().str().str();
}
  
std::string moduleName(const Decl* Declaration) {
  return Declaration->getModuleContext()->getBaseName().getIdentifier().get();
}

ModuleNameAndParts moduleNameAndParts(const Decl *Declaration) {
  std::string ModuleName = moduleName(Declaration);
  std::vector<std::string> Parts;
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
  
template<class T>
const T* baseOverridenDeclarationWithModules(const T *Declaration,
                                            std::set<std::string> &Modules) {
  static_assert(std::is_base_of<Decl, T>::value, "T is not a subclass of Decl");
  if (auto* OverrideDeclaration = Declaration->getOverriddenDecl()) {
    Modules.insert(moduleName(OverrideDeclaration));
    return baseOverridenDeclarationWithModules(OverrideDeclaration, Modules);
  } else {
    return Declaration;
  }
}

template const VarDecl*
baseOverridenDeclarationWithModules(const VarDecl *Declaration,
                                    std::set<std::string> &Modules);
template const FuncDecl*
baseOverridenDeclarationWithModules(const FuncDecl *Declaration,
                                    std::set<std::string> &Modules);

} //namespace obfuscation
} //namespace swift

