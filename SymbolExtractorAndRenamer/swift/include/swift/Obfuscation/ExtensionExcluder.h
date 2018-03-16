#ifndef ExtensionExcluder_h
#define ExtensionExcluder_h

#include "swift/Obfuscation/Excluder.h"

namespace swift {
namespace obfuscation {

class ExtensionExcluder: public Excluder {

public:

    void identifyExclusions(Decl *Declaration);    
};

} //namespace obfuscation
} //namespace swift

#endif /* ExtensionExcluder_h */
