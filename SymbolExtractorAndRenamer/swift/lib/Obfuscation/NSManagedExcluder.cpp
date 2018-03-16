#include "swift/Obfuscation/NSManagedExcluder.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParser.h"

namespace swift {
namespace obfuscation {
    
void NSManagedExcluder::
identifyExclusions(Decl *Declaration) {
  
  if(auto NominalDeclaration = dyn_cast<NominalTypeDecl>(Declaration)) {
    
    auto ClassOrExtensionCtx
                      = NominalDeclaration->getAsClassOrClassExtensionContext();
    
    if(ClassOrExtensionCtx != nullptr) {
    
      auto SuperClass = NominalDeclaration->getAsClassOrClassExtensionContext()->getSuperclassDecl();
      if(SuperClass != nullptr) {
        
        if(SuperClass->getName().str() == "NSManagedObject") {
          DeclarationsToExclude.insert(NominalDeclaration);
        }
      }
    }
    
  } else if (auto *VariableDeclaration = dyn_cast<VarDecl>(Declaration)) {
    
    if(VariableDeclaration->getAttrs().hasAttribute<NSManagedAttr>()) {
      DeclarationsToExclude.insert(VariableDeclaration);
    }
  }
}
  
} //namespace obfuscation
} //namespace swift
