#ifndef ConfigurationExcluder_h
#define ConfigurationExcluder_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Excluder.h"

namespace swift {
namespace obfuscation {

class ConfigurationExcluder: public Excluder {

private:

  ObfuscationConfiguration Configuration;

  void excludeIfNeeded(Decl *Declaration,
                       const std::pair<const ClassDecl *, std::string> &DeclarationAndModule,
                       const InheritanceExclusion *ExcludedType);

  void handleTypeExclusion(const TypeExclusion *Exclusion, Decl *Declaration);

  void handleInheritanceExclusion(const InheritanceExclusion *Exclusion,
                                  Decl *Declaration);

  void handleConformanceExclusion(const ConformanceExclusion *Exclusion,
                                  Decl *Declaration);

public:

  ConfigurationExcluder(ObfuscationConfiguration&&);
  
  void identifyExclusions(Decl *Declaration);
};


} // namespace obfuscation
} // namespace swift

#endif /* ConfigurationExcluder_h */
