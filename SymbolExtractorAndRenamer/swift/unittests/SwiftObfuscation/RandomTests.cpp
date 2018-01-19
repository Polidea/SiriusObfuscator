#include "swift/Obfuscation/Random.h"

#include "gtest/gtest.h"
#include "gmock/gmock.h"

namespace swift {
namespace obfuscation {
  
struct FakeEngine {
  static FakeEngine* CreatedInstance;
  
  FakeEngine(int seed) {
    CreatedInstance = this;
  };
};

struct FakeDistribution {
  
  static std::pair<int, int> CatchedMinMax;
  static FakeEngine* CatchedInstance;
  
  static int MockRandNumber;
  
  static int NumberOfGenerationCalls;
  
  FakeDistribution(int Min, int Max) {
    CatchedMinMax = std::make_pair(Min, Max);
  }
  
  int operator()(FakeEngine& g) {
    NumberOfGenerationCalls += 1;
    CatchedInstance = &g;
    return MockRandNumber;
  }
};

FakeEngine* FakeEngine::CreatedInstance;
std::pair<int, int> FakeDistribution::CatchedMinMax;
int FakeDistribution::MockRandNumber;
int FakeDistribution::NumberOfGenerationCalls;
FakeEngine* FakeDistribution::CatchedInstance;

using FakeRandomIntegerGenerator =
  swift::obfuscation::RandomIntegerGenerator<FakeEngine, FakeDistribution>;
  
class RandomTests : public ::testing::Test {
  void cleanStatics() {
    FakeEngine::CreatedInstance = nullptr;
    FakeDistribution::CatchedMinMax = std::make_pair(0, 0);
    FakeDistribution::MockRandNumber = 0;
    FakeDistribution::NumberOfGenerationCalls = 0;
    FakeDistribution::CatchedInstance = nullptr;
  }
  
  virtual void SetUp() override {
    cleanStatics();
  }
  
  virtual void TearDown() override {
    cleanStatics();
  }
};
  
class RandomIntegerGeneratorTests : public RandomTests {};

TEST_F(RandomIntegerGeneratorTests, DelegatesRandomGenerationToDistribution) {
  FakeRandomIntegerGenerator Generator(0, 1);
  int TestRandomNumber = 42;
  FakeDistribution::MockRandNumber = TestRandomNumber;
  
  int Result = Generator.rand();
  
  EXPECT_EQ(Result, TestRandomNumber);
}
  
TEST_F(RandomIntegerGeneratorTests, PassesTheDistributionParameters) {
  int TestMin = 100;
  int TestMax = 1000;
  
  FakeRandomIntegerGenerator Generator(TestMin, TestMax);
  
  EXPECT_EQ(TestMin, FakeDistribution::CatchedMinMax.first);
  EXPECT_EQ(TestMax, FakeDistribution::CatchedMinMax.second);
}
  
TEST_F(RandomIntegerGeneratorTests, PreventsUndefinedDistributionInitialization) {
  int TestMin = 1000;
  int TestMax = 100;
  
  EXPECT_DEATH(FakeRandomIntegerGenerator Generator(TestMin, TestMax), "");
}
  
TEST_F(RandomIntegerGeneratorTests, CreatesEngineInstanceAndUsesItInGeneration) {
  FakeRandomIntegerGenerator Generator(0, 1);
  Generator.rand();
  
  EXPECT_EQ(FakeEngine::CreatedInstance, FakeDistribution::CatchedInstance);
  EXPECT_EQ(FakeDistribution::NumberOfGenerationCalls, 1);
}
  
class RandomElementChooserTests : public RandomTests {};
  
using FakeRandomElementChooser =
  RandomElementChooser<std::string, FakeRandomIntegerGenerator>;

TEST_F(RandomElementChooserTests, PreventsFromInitializationWithEmptyList) {
  std::vector<std::string> TestList;
  
  EXPECT_DEATH(FakeRandomElementChooser ElementChooser(TestList), "");
}

TEST_F(RandomElementChooserTests, DelegatesRandomGenerationToGenerator) {
  std::vector<std::string> TestList = {"test"};
  FakeRandomElementChooser ElementChooser(TestList);
  int RandomTimes = 5;
  
  for (int i = 0; i < RandomTimes; ++i) {
    ElementChooser.rand();
  }
  
  EXPECT_EQ(FakeDistribution::NumberOfGenerationCalls, RandomTimes);
}

TEST_F(RandomElementChooserTests, GeneratorRangeIsTheSameAsListIndices) {
  int NumberOfElements = 20;
  std::vector<std::string> TestList(NumberOfElements, "test");
  
  FakeRandomElementChooser ElementChooser(TestList);
  
  EXPECT_EQ(FakeDistribution::CatchedMinMax.first, 0);
  EXPECT_EQ(FakeDistribution::CatchedMinMax.second, NumberOfElements - 1);
}

TEST_F(RandomElementChooserTests, ReturnsElementDictatedByGenerator) {
  std::vector<std::string> TestList = {"a", "b", "c", "d", "e"};
  FakeRandomElementChooser ElementChooser(TestList);
  
  for (std::vector<std::string>::size_type i = 0; i < TestList.size(); ++i) {
    FakeDistribution::MockRandNumber = i;
    auto Element = ElementChooser.rand();
    EXPECT_EQ(Element, TestList.at(i));
  }
}
  
class RandomVectorGeneratorTests : public RandomTests {};
  
using FakeRandomVectorGenerator =
  RandomVectorGenerator<std::string, FakeRandomElementChooser>;
  
TEST_F(RandomVectorGeneratorTests, PreventsFromInitializationWithEmptyList) {
  std::vector<std::string> TestList;
  
  EXPECT_DEATH(FakeRandomVectorGenerator Generator(TestList), "");
}
  
TEST_F(RandomVectorGeneratorTests, GivesResultOfLenghtZeroWhenAskedFor) {
  std::vector<std::string> EmptyList;
  std::vector<std::string> TestList = {"a"};
  FakeRandomVectorGenerator Generator(TestList);
  
  auto Result = Generator.rand(0);
  
  EXPECT_EQ(Result, EmptyList);
}

TEST_F(RandomVectorGeneratorTests, CallsElementChooserForEachElementToChoose) {
  std::vector<std::string> TestList = {"a", "b", "c", "d", "e"};
  FakeRandomVectorGenerator Generator(TestList);
  int RandomTimes = 20;
  
  Generator.rand(RandomTimes);
  
  EXPECT_EQ(FakeDistribution::NumberOfGenerationCalls, RandomTimes);
}

TEST_F(RandomVectorGeneratorTests, ReturnVectorOfElementsFromElementChooser) {
  std::vector<std::string> TestList = {"a", "b", "c", "d", "e"};
  FakeRandomVectorGenerator Generator(TestList);
  int RandomTimes = 20;
  
  for (std::vector<std::string>::size_type i = 0; i < TestList.size(); ++i) {
    FakeDistribution::MockRandNumber = i;
    auto Result = Generator.rand(RandomTimes);
    std::vector<std::string> Expected(RandomTimes, TestList.at(i));
    EXPECT_EQ(Result, Expected);
  }
}

class RandomStringGeneratorTests : public RandomTests {};
  
using FakeRandomStringGenerator =
  RandomStringGenerator<FakeRandomElementChooser>;
                                      
TEST_F(RandomStringGeneratorTests, PreventsFromInitializationWithEmptyList) {
  std::vector<std::string> TestList;

  EXPECT_DEATH(FakeRandomStringGenerator Generator(TestList), "");
}

TEST_F(RandomStringGeneratorTests, GivesResultOfLenghtZeroWhenAskedFor) {
  std::string EmptyString;
  std::vector<std::string> TestList = {"a"};
  FakeRandomStringGenerator Generator(TestList);
  
  auto Result = Generator.rand(0);
  
  EXPECT_EQ(Result, EmptyString);
}

TEST_F(RandomStringGeneratorTests, CallsGeneratorWithLengthFromParameter) {
  std::vector<std::string> TestList = {"a", "b", "c", "d", "e"};
  FakeRandomStringGenerator Generator(TestList);
  int RandomTimes = 20;
  
  Generator.rand(RandomTimes);
  
  EXPECT_EQ(FakeDistribution::NumberOfGenerationCalls, RandomTimes);
}

TEST_F(RandomStringGeneratorTests, ReturnsStringOfCharactersFromGenerator) {
  std::vector<std::string> TestList = {"a", "b", "c", "d", "e"};
  std::vector<std::string> ExpectedList = {"aaaaa", "bbbbb", "ccccc",
                                           "ddddd", "eeeee"};
  FakeRandomStringGenerator Generator(TestList);
  int Length = 5;
  
  for (std::vector<std::string>::size_type i = 0; i < TestList.size(); ++i) {
    FakeDistribution::MockRandNumber = i;
    auto Result = Generator.rand(Length);
    EXPECT_EQ(Result, ExpectedList.at(i));
  }
}
  
}
}
