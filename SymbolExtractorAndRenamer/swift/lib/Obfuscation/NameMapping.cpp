#include "swift/Obfuscation/NameMapping.h"
#include "swift/Obfuscation/Random.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

class UniqueIdentifierGenerator {
  
private:
  std::set<std::string> GeneratedSymbols;
  static const std::vector<std::string> UniquelyTailSymbols;
  static const std::vector<std::string> HeadSymbols;
  std::vector<std::string> TailSymbols;
  RandomUniformCharacterChooser HeadGenerator;
  RandomUniformStringGenerator TailGenerator;
  const std::string::size_type IdentifierLength = 32;
  
  llvm::Expected<std::string> generateName(int NumbersOfTriesLeft) {
    if (NumbersOfTriesLeft <= 0) {
      return stringError("couldn't generate unique type name");
    }
    auto Head = HeadGenerator.rand();
    auto Tail = TailGenerator.rand(IdentifierLength - 1);
    auto Name = Head + Tail;
    
    if (GeneratedSymbols.insert(Name).second) {
      return Name;
    } else {
      return generateName(NumbersOfTriesLeft - 1);
    }
  }
  
  static std::vector<std::string> concatenateHeadAndTailSymbols() {
    std::vector<std::string> TemporaryTailSymbols = UniquelyTailSymbols;
    TemporaryTailSymbols.insert(TemporaryTailSymbols.cend(),
                                HeadSymbols.cbegin(),
                                HeadSymbols.cend());
    return TemporaryTailSymbols;
  }
  
public:
  
  UniqueIdentifierGenerator()
  : TailSymbols(concatenateHeadAndTailSymbols()),
  HeadGenerator(HeadSymbols),
  TailGenerator(TailSymbols) {}
  
  llvm::Expected<std::string> generateName() {
    return generateName(100);
  }
  
};
  
const std::vector<std::string> UniqueIdentifierGenerator::UniquelyTailSymbols =
  {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
  
const std::vector<std::string> UniqueIdentifierGenerator::HeadSymbols =
  {"_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
   "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C",
   "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
   "S", "T", "U", "V", "W", "X", "Y", "Z"};
  
struct ObfuscatedIdentifiersGenerators {
  UniqueIdentifierGenerator IdentifierGenerator;
};

llvm::Expected<std::string>
generateNameForType(ObfuscatedIdentifiersGenerators &Generators,
                    SymbolType Type) {
  switch (Type) {
    case SymbolType::Type:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::NamedFunction:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::ExternalParameter:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::InternalParameter:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::SingleParameter:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::Variable:
      return Generators.IdentifierGenerator.generateName();
    case SymbolType::Operator:
      return stringError("Operator names are not supported yet");
  }
}
  
llvm::Expected<RenamesJson>
proposeRenamings(const SymbolsJson &SymbolsJson) {
  
  ObfuscatedIdentifiersGenerators Generators;
  RenamesJson RenamesJson;
  
  for (const auto &Symbol : SymbolsJson.Symbols) {
    SymbolRenaming Renaming;
    Renaming.Identifier = Symbol.Identifier;
    Renaming.OriginalName = Symbol.Name;
    Renaming.Module = Symbol.Module;
    Renaming.Type = Symbol.Type;
    auto NameOrError = generateNameForType(Generators, Symbol.Type);
    if (auto Error = NameOrError.takeError()) {
      return std::move(Error);
    }
    Renaming.ObfuscatedName = NameOrError.get(); // "obfuscated" + Symbol.Name;
    RenamesJson.Symbols.push_back(Renaming);
  }
  
  return RenamesJson;
}

} //namespace obfuscation
} //namespace swift
