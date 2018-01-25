#ifndef Random_h
#define Random_h

#include "swift/Obfuscation/Utils.h"

#include <cassert>
#include <vector>
#include <string>
#include <random>

namespace swift {
namespace obfuscation {

/// Generates integer value from a specified [Min; Max] range.
///
/// \tparam EngineType random number engine type such as std::mt19937
/// \tparam DistributionType type of probability distribution
/// such as std::uniform_int_distribution<int>
template<typename EngineType, typename DistributionType>
class RandomIntegerGenerator {
  
private:
  
  EngineType Engine;
  DistributionType Distribution;
  
public:
  
  RandomIntegerGenerator(int Min, int Max);
  
  int rand();

};
 
/// Chooses random element from the specified vector.
///
/// \tparam ElementType type of the elements in vector
/// \tparam GeneratorType type of the generator used to generate the index
/// of chosen element
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

/// Generates the vector of elements randomly chosen from the specified vector.
///
/// \tparam ElementType type of the elements in vector
/// \tparam ChooserType class that generates random elements from predefined set
template<typename ElementType, typename ChooserType>
class RandomVectorGenerator {
  
private:
  
  ChooserType Chooser;
  
public:
  
  RandomVectorGenerator(const std::vector<ElementType> &ListToChooseFrom);
  
  std::vector<ElementType> rand(length_type<ElementType> Length);

};

/// Generates string of specified length containing elements randomly chosed
/// from the specified vector.
///
/// \tparam ChooserType type of the chooser used by RandomVectorGenerator
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
