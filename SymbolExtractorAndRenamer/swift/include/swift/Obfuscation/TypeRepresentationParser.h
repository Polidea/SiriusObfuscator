#ifndef TypeRepresentationParser_h
#define TypeRepresentationParser_h

#import "swift/AST/TypeRepr.h"

#include <set>

namespace swift {
namespace obfuscation {

class TypeRepresentationParser {

private:

  std::set<SymbolWithRange> Symbols;

public:

  void collectSymbolsFromTypeRepresentation(
                                      GlobalCollectedSymbols &CollectedSymbols,
                                      TypeRepr *TypeRepresentation);

  std::set<SymbolWithRange> harvestSymbols();

private:

  void handleComponent(GlobalCollectedSymbols &CollectedSymbols,
                       ComponentIdentTypeRepr *Component);

  void handleTypeRepresentationRecursively(
                                       GlobalCollectedSymbols &CollectedSymbols,
                                       TypeRepr *ParentOfTypeRepresentation,
                                       TypeRepr *TypeRepresentation);

};

} //namespace obfuscation
} //namespace swift

#endif /* TypeRepresentationParser_h */
