#ifndef Random_h
#define Random_h

#include <cassert>
#include <vector>
#include <string>
#include <random>

namespace swift {
namespace obfuscation {

template<typename EngineType, typename DistributionType>
class RandomIntegerGenerator {
  
private:
  
  EngineType Engine;
  DistributionType Distribution;
  
public:
  
  RandomIntegerGenerator(int Min, int Max);
  
  int rand();

};

template<typename ElementType, typename GeneratorType>
class RandomElementChooser {
  
private:
  
  GeneratorType Generator;
  std::vector<ElementType> List;
  
public:
  
  RandomElementChooser(const std::vector<ElementType> &ListToChooseFrom);
  
  ElementType rand();

};

template<typename ElementType>
using length_type = typename std::vector<ElementType>::size_type;

template<typename ElementType, typename ChooserType>
class RandomVectorGenerator {
  
private:
  
  ChooserType Chooser;
  
public:
  
  RandomVectorGenerator(const std::vector<ElementType> &ListToChooseFrom);
  
  std::vector<ElementType> rand(length_type<ElementType> Length);

};

template<typename ChooserType>
class RandomStringGenerator {
  
private:
  
  RandomVectorGenerator<std::string, ChooserType> Generator;
  
public:
  
  RandomStringGenerator(const std::vector<std::string> &ListToChooseFrom);
  
  std::string rand(length_type<std::string> Length);

};
  
using RandomUniformIntGenerator =
  RandomIntegerGenerator<std::mt19937, std::uniform_int_distribution<int>>;
  
using RandomUniformCharacterChooser =
  RandomElementChooser<std::string, RandomUniformIntGenerator>;
  
using RandomUniformStringGenerator =
  RandomStringGenerator<RandomUniformCharacterChooser>;

} //namespace obfuscation
} //namespace swift

#include "Random-Template.h"

#endif /* Random_h */
