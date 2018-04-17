#ifndef Collector_h
#define Collector_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Includer.h"
#include "swift/Obfuscation/SymbolGenerator.h"

#include <vector>

namespace swift {
namespace obfuscation {

class Collector {

private:
  std::unique_ptr<class Includer> Includer;
  std::unique_ptr<class SymbolGenerator> SymbolGenerator;

public:

  Collector(std::unique_ptr<class Includer>,
            std::unique_ptr<class SymbolGenerator>);

  std::vector<DeclWithSymbolWithRange> collectFrom(DeclWithRange &);
  std::vector<DeclWithSymbolWithRange> collectFrom(DeclWithRange &&);

};

} //namespace obfuscation
} //namespace swift

#endif /* Collector_h */
