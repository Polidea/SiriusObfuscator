#include "swift/Obfuscation/NameMapping.h"
#include "swift/Obfuscation/Random.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

class UniqueTypeNameGenerator {
  
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
  
  UniqueTypeNameGenerator()
  : TailSymbols(concatenateHeadAndTailSymbols()),
  HeadGenerator(HeadSymbols),
  TailGenerator(TailSymbols) {}
  
  llvm::Expected<std::string> generateName() {
    return generateName(100);
  }
  
};
  
const std::vector<std::string> UniqueTypeNameGenerator::UniquelyTailSymbols =
  {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
  
const std::vector<std::string> UniqueTypeNameGenerator::HeadSymbols =
  {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
   "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
   "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
   "T", "U", "V", "W", "X", "Y", "Z"};

llvm::Expected<RenamesJson> proposeRenamings(const SymbolsJson &SymbolsJson) {
  
  UniqueTypeNameGenerator TypeNameGenerator;
  RenamesJson RenamesJson;
  
  for (const auto &Symbol : SymbolsJson.Symbols) {
    SymbolRenaming Renaming;
    Renaming.Identifier = Symbol.Identifier;
    Renaming.OriginalName = Symbol.Name;
    Renaming.Module = Symbol.Module;
    auto NameOrError = TypeNameGenerator.generateName();
    if (auto Error = NameOrError.takeError()) {
      return std::move(Error);
    }
    Renaming.ObfuscatedName = NameOrError.get();
    RenamesJson.Symbols.push_back(Renaming);
  }
  
  return RenamesJson;
}

} //namespace obfuscation
} //namespace swift
