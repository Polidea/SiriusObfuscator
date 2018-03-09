#ifndef ExtensionExcluder_h
#define ExtensionExcluder_h

#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

namespace swift {
namespace obfuscation {

class ExtensionExcluder {

private:

  std::set<Decl *> DeclarationsToExclude;

public:

  void identifyExclusionsFromExtension(const ExtensionDecl *Declaration);

  std::vector<IndexedSymbolWithRange>
  excludeSymbolsFrom(GlobalCollectedSymbols &CollectedSymbols);

};

} //namespace obfuscation
} //namespace swift

#endif /* ExtensionExcluder_h */
