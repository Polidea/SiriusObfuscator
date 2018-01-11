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
  const std::vector<std::string> HeadSymbols = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
  std::vector<std::string> TailSymbols;
  RandomElementChooser<std::string>* HeadGenerator;
  RandomStringGenerator* TailGenerator;
  const std::string::size_type IdentifierLength = 32;
  
  llvm::Expected<std::string> generateName(int NumbersOfTriesLeft) {
    if (NumbersOfTriesLeft <= 0) {
      return stringError("couldn't generate unique type name");
    }
    auto Head = HeadGenerator->rand();
    auto Tail = TailGenerator->rand(IdentifierLength - 1);
    auto Name = Head + Tail;
    
    if (GeneratedSymbols.insert(Name).second) {
      return Name;
    } else {
      return this->generateName(NumbersOfTriesLeft - 1);
    }
  }
  
public:
  
  UniqueTypeNameGenerator() {
    TailSymbols = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};
    TailSymbols.insert(TailSymbols.end(),
                       HeadSymbols.begin(),
                       HeadSymbols.end());
    HeadGenerator = new RandomElementChooser<std::string>(HeadSymbols);
    TailGenerator = new RandomStringGenerator(TailSymbols);
  }
  
  
  llvm::Expected<std::string> generateName() {
    return generateName(100);
  }
  
  ~UniqueTypeNameGenerator() {
    delete HeadGenerator;
    delete TailGenerator;
  }
  
};

llvm::Expected<RenamesJson> proposeRenamings(const SymbolsJson &SymbolsJson) {
  
  auto *TypeNameGenerator = new UniqueTypeNameGenerator();
  
  RenamesJson RenamesJson;
  
  for (const auto &Symbol : SymbolsJson.Symbols) {
    SymbolRenaming Renaming;
    Renaming.Identifier = Symbol.Identifier;
    Renaming.OriginalName = Symbol.Name;
    auto NameOrError = TypeNameGenerator->generateName();
    if (auto Error = NameOrError.takeError()) {
      return std::move(Error);
    }
    Renaming.ObfuscatedName = NameOrError.get();
    RenamesJson.Symbols.push_back(Renaming);
  }
  
  delete TypeNameGenerator;

  return RenamesJson;
}

} //namespace obfuscation
} //namespace swift
