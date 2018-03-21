#ifndef ConfigurationExcluder_h
#define ConfigurationExcluder_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Excluder.h"

namespace swift {
namespace obfuscation {

class ConfigurationExcluder: public Excluder {

private:

  ObfuscationConfiguration Configuration;

public:

  ConfigurationExcluder(ObfuscationConfiguration&&);

  void identifyExclusions(Decl *Declaration);
};


} // namespace obfuscation
} // namespace swift

#endif /* ConfigurationExcluder_h */
