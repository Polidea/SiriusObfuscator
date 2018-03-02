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

  void collectSymbolsFromTypeRepresentation(TypeRepr *TypeRepresentation);

  std::set<SymbolWithRange> harvestSymbols();

private:

  void handleComponent(ComponentIdentTypeRepr *Component);

  void handleTypeRepresentationRecursively(TypeRepr *ParentOfTypeRepresentation,
                                           TypeRepr *TypeRepresentation);

};

} //namespace obfuscation
} //namespace swift

#endif /* TypeRepresentationParser_h */
