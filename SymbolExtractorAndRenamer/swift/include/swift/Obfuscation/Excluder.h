#ifndef Excluder_h
#define Excluder_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

namespace swift {
namespace obfuscation {
  
/// A base class for excluders
class Excluder {
  
protected:
  
  std::set<Decl *> DeclarationsToExclude;
  
public:
  virtual ~Excluder() = default;
  
  virtual void identifyExclusions(Decl *Declaration) = 0;
  
  void excludeSymbolsFrom(GlobalCollectedSymbols &CollectedSymbols);
  
};
  
} //namespace obfuscation
} //namespace swift


#endif /* Excluder_h */
