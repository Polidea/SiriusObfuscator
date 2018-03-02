#include "swift/Obfuscation/NameMapping.h"
#include "swift/Obfuscation/Random.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

const std::vector<std::string> BaseIdentifierGenerator::UniquelyTailSymbols =
  {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

const std::vector<std::string> BaseIdentifierGenerator::HeadSymbols =
  {"_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C",
    "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
    "S", "T", "U", "V", "W", "X", "Y", "Z"};

// "/" symbol is omitted to avoid generating comments in operator names
const std::vector<std::string> BaseIdentifierGenerator::HeadOperatorSymbols =
  {"=", "-", "+", "*", "%", "<", ">", "&", "|", "^", "~"};
  // "/" symbol is omitted to avoid generating comments in operator names
const std::vector<std::string>
BaseIdentifierGenerator::UniquelyTailOperatorSymbols =
  {"!", "?"};


std::vector<std::string>
BaseIdentifierGenerator::
  concatenateSymbols(const std::vector<std::string> &Head,
                     const std::vector<std::string> &Tail) {
  std::vector<std::string> TemporaryTailSymbols = Tail;
  TemporaryTailSymbols.insert(TemporaryTailSymbols.cend(),
                              Head.cbegin(),
                              Head.cend());
  return TemporaryTailSymbols;
}
  
/// Generates random unique identifiers for symbols.
class RandomUniqueIdentifierGenerator: public BaseIdentifierGenerator {
  std::set<std::string> GeneratedSymbols;
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
  
public:
  RandomUniqueIdentifierGenerator()
  : HeadGenerator(HeadSymbols),
    TailGenerator(concatenateSymbols(HeadSymbols, UniquelyTailSymbols)) {}
  
  llvm::Expected<std::string> generateName(const Symbol &Symbol) {
    return generateName(100);
  }
  
};

/// Generates random unique identifiers for operators.
class RandomUniqueOperatorGenerator: public BaseIdentifierGenerator {
  std::set<std::string> GeneratedSymbols;
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

public:

  RandomUniqueOperatorGenerator()
  : HeadGenerator(HeadOperatorSymbols),
    TailGenerator(concatenateSymbols(HeadOperatorSymbols,
                                     UniquelyTailOperatorSymbols)) {}

  llvm::Expected<std::string> generateName(const Symbol &Symbol) {
    return generateName(100);
  }
};
  
/// Generates deterministic identifiers for symbols.
/// Used in tests.
class DeterministicIdentifierGenerator: public BaseIdentifierGenerator {
  
public:
  
  llvm::Expected<std::string> generateName(const Symbol &Symbol) {
    
    auto &MapForType = SymbolTypeMap[Symbol.Type];
    int SymbolNameCount = MapForType[Symbol.Name];
    MapForType[Symbol.Name] = ++SymbolNameCount;
    
    return SymbolShortNameMap[Symbol.Type] + std::to_string(SymbolNameCount) + "_" + Symbol.Name;
  }
  
};

// NameMapping implementation
  
NameMapping::NameMapping(enum NameMappingStrategy NameMappingStrategy):
  NameMappingStrategy(NameMappingStrategy) {};
  
llvm::Expected<std::string>
  NameMapping::generateNameForSymbol(const Symbol &Symbol) {
    
  switch (Symbol.Type) {
    case SymbolType::Type:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::NamedFunction:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::ExternalParameter:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::InternalParameter:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::SingleParameter:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::Variable:
      return IdentifierGenerator->generateName(Symbol);
    case SymbolType::Operator:
      return OperatorGenerator->generateName(Symbol);
  }
}
  
llvm::Expected<RenamesJson>
  NameMapping::proposeRenamings(const SymbolsJson &SymbolsJson) {
  
  if(NameMappingStrategy == NameMappingStrategy::random) {
    this->IdentifierGenerator = llvm::make_unique<RandomUniqueIdentifierGenerator>();
    this->OperatorGenerator = llvm::make_unique<RandomUniqueOperatorGenerator>();
  } else if(NameMappingStrategy == NameMappingStrategy::deterministic) {
    this->IdentifierGenerator = llvm::make_unique<DeterministicIdentifierGenerator>();
    this->OperatorGenerator = llvm::make_unique<DeterministicIdentifierGenerator>();
  }
    
  RenamesJson RenamesJson;
  
  for (const auto &Symbol : SymbolsJson.Symbols) {
    SymbolRenaming Renaming;
    Renaming.Identifier = Symbol.Identifier;
    Renaming.OriginalName = Symbol.Name;
    Renaming.Module = Symbol.Module;
    Renaming.Type = Symbol.Type;
    auto NameOrError = generateNameForSymbol(Symbol);
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
