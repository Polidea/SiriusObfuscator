#ifndef NSManagedExcluder_h
#define NSManagedExcluder_h

#include "swift/Obfuscation/Excluder.h"

namespace swift {
namespace obfuscation {
  
class NSManagedExcluder: public Excluder {
  
public:
  
  void identifyExclusions(Decl *Declaration);
};
  
} //namespace obfuscation
} //namespace swift

#endif /* NSManagedExcluder_h */
