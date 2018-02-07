#include "swift/Obfuscation/DataStructures.h"
#include "gtest/gtest.h"

using namespace swift::obfuscation;
using namespace llvm::yaml;

template<class T>
bool vectorContains(const std::vector<T> &Vector, const T &Element) {
  return std::end(Vector) != std::find(Vector.begin(), Vector.end(), Element);
}

TEST(DataStructuresDeserialization, DeserializeProject) {
  std::string JsonString = "{\n\"rootPath\": \"sampleRootPath\"\n,"
                           " \n\"projectFilePath\": \"sampleProjectFilePath\"\n}";
  
  auto DeserializedOrError = deserialize<Project>(JsonString);
  
  auto Expected = Project();
  Expected.RootPath = "sampleRootPath";
  Expected.ProjectFilePath = "sampleProjectFilePath";
  
  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  EXPECT_EQ(Deserialized.RootPath, Expected.RootPath);
  EXPECT_EQ(Deserialized.ProjectFilePath, Expected.ProjectFilePath);
}

TEST(DataStructuresDeserialization, DeserializeModule) {
  std::string JsonString = "{\n\"name\": \"sampleName\","
                           "\"triple\": \"sampleTriple\"\n}";

  auto DeserializedOrError = deserialize<Module>(JsonString);

  auto Expected = Module();
  Expected.Name = "sampleName";
  Expected.TargetTriple = "sampleTriple";
  
  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();

  EXPECT_EQ(Deserialized.Name, Expected.Name);
  EXPECT_EQ(Deserialized.TargetTriple, Expected.TargetTriple);
}

TEST(DataStructuresDeserialization, DeserializeSdk) {
  std::string JsonString = "{\n"
  "\"name\": \"sampleName\"\n,"
  "\"path\": \"samplePath\",\n}";

  auto DeserializedOrError = deserialize<Sdk>(JsonString);

  auto Expected = Sdk();
  Expected.Name = "sampleName";
  Expected.Path = "samplePath";

  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  EXPECT_EQ(Deserialized.Name, Expected.Name);
}

TEST(DataStructuresDeserialization, DeserializeExplicitlyLinkedFramework) {
  std::string JsonString = "{\n"
  "\"name\": \"sampleName\"\n,"
  "\"path\": \"samplePath\",\n}";

  auto DeserializedOrError = deserialize<ExplicitlyLinkedFrameworks>(JsonString);

  auto Expected = ExplicitlyLinkedFrameworks();
  Expected.Name = "sampleName";
  Expected.Path = "samplePath";

  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  EXPECT_EQ(Deserialized.Name, Expected.Name);
}

TEST(DataStructuresDeserialization, DeserializeSymbolsJson) {
  std::string JsonString =
  "{\n"
  "symbols: [\n"
  "{\n"
  "\"name\": \"sampleName0\",\n"
  "\"identifier\": \"sampleIdentifier0\",\n"
  "\"module\": \"sampleModule0\",\n"
  "\"type\": \"type\"\n"
  "},\n"
  "{\n"
  "\"name\": \"sampleName1\",\n"
  "\"identifier\": \"sampleIdentifier1\",\n"
  "\"module\": \"sampleModule1\",\n"
  "\"type\": \"namedFunction\"\n"
  "},\n"
  "{\n"
  "\"name\": \"sampleName2\",\n"
  "\"identifier\": \"sampleIdentifier2\",\n"
  "\"module\": \"sampleModule2\",\n"
  "\"type\": \"operator\"\n"
  "}\n"
  "]\n"
  "}";

  auto DeserializedOrError = deserialize<SymbolsJson>(JsonString);

  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  size_t ExpectedSize = 3;
  EXPECT_EQ(Deserialized.Symbols.size(), ExpectedSize);

  Symbol Expected0("sampleIdentifier0", "sampleName0", "sampleModule0", SymbolType::Type);
  Symbol Expected1("sampleIdentifier1", "sampleName1", "sampleModule1", SymbolType::NamedFunction);
  Symbol Expected2("sampleIdentifier2", "sampleName2", "sampleModule2", SymbolType::Operator);

  EXPECT_TRUE(vectorContains<Symbol>(Deserialized.Symbols, Expected0));
  EXPECT_TRUE(vectorContains<Symbol>(Deserialized.Symbols, Expected1));
  EXPECT_TRUE(vectorContains<Symbol>(Deserialized.Symbols, Expected2));
}

TEST(DataStructuresDeserialization, DeserializeSymbol) {
  std::string JsonString = "{\n"
  "\"name\": \"sampleName\"\n,"
  "\"identifier\": \"sampleIdentifier\",\n"
  "\"type\": \"type\",\n"
  "\"module\": \"sampleModule\"\n}";

  auto DeserializedOrError = deserialize<Symbol>(JsonString);

  Symbol Expected("sampleIdentifier", "sampleName", "sampleModule", SymbolType::Type);

  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  EXPECT_EQ(Deserialized, Expected);
}

TEST(DataStructuresDeserialization, DeserializeRenamesJson) {
  std::string JsonString =
  "{\n"
  "symbols: [\n"
  "{\n"
  "\"identifier\": \"sampleIdentifier0\",\n"
  "\"originalName\": \"sampleName0\",\n"
  "\"obfuscatedName\": \"sampleObfuscatedName0\",\n"
  "\"module\": \"sampleModule0\",\n"
  "\"type\": \"type\"\n"
  "},\n"
  "{\n"
  "\"identifier\": \"sampleIdentifier1\",\n"
  "\"originalName\": \"sampleName1\",\n"
  "\"obfuscatedName\": \"sampleObfuscatedName1\",\n"
  "\"module\": \"sampleModule1\",\n"
  "\"type\": \"namedFunction\"\n"
  "},\n"
  "{\n"
  "\"identifier\": \"sampleIdentifier2\",\n"
  "\"originalName\": \"sampleName2\",\n"
  "\"obfuscatedName\": \"sampleObfuscatedName2\",\n"
  "\"module\": \"sampleModule2\",\n"
  "\"type\": \"operator\"\n"
  "}\n"
  "]\n"
  "}";

  auto DeserializedOrError = deserialize<RenamesJson>(JsonString);

  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  size_t ExpectedSize = 3;
  EXPECT_EQ(Deserialized.Symbols.size(), ExpectedSize);

  SymbolRenaming Expected0("sampleIdentifier0", "sampleName0", "sampleObfuscatedName0", "sampleModule0", SymbolType::Type);
  SymbolRenaming Expected1("sampleIdentifier1", "sampleName1", "sampleObfuscatedName1", "sampleModule1", SymbolType::NamedFunction);
  SymbolRenaming Expected2("sampleIdentifier2", "sampleName2", "sampleObfuscatedName2", "sampleModule2", SymbolType::Operator);

  EXPECT_TRUE(vectorContains<SymbolRenaming>(Deserialized.Symbols, Expected0));
  EXPECT_TRUE(vectorContains<SymbolRenaming>(Deserialized.Symbols, Expected1));
  EXPECT_TRUE(vectorContains<SymbolRenaming>(Deserialized.Symbols, Expected2));
}

TEST(DataStructuresDeserialization, DeserializeSymbolRenaming) {
  std::string JsonString = "{\n"
  "\"originalName\": \"sampleName\"\n,"
  "\"identifier\": \"sampleIdentifier\",\n"
  "\"obfuscatedName\": \"sampleObfuscatedName\",\n"
  "\"type\": \"type\",\n"
  "\"module\": \"sampleModule\"\n}";

  auto DeserializedOrError = deserialize<SymbolRenaming>(JsonString);

  auto Expected = SymbolRenaming("sampleIdentifier",
                                 "sampleName",
                                 "sampleObfuscatedName",
                                 "sampleModule",
                                 SymbolType::Type);
  
  if (auto ErrorCode = DeserializedOrError.takeError()) {
    llvm::consumeError(std::move(ErrorCode));
    FAIL() << "Error during json parsing";
  }
  auto Deserialized = DeserializedOrError.get();
  
  EXPECT_EQ(Deserialized, Expected);
}
