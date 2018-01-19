#ifndef RandomTemplate_h
#define RandomTemplate_h

#include <sstream>

namespace swift {
namespace obfuscation {

template<typename EngineType, typename DistributionType>
RandomIntegerGenerator<EngineType, DistributionType>::
  RandomIntegerGenerator(int Min, int Max)
: Engine(std::random_device()()), Distribution(Min, Max) {
  assert(Min <= Max && "The inverted min and max lead to undefined behavior");
}

template<typename EngineType, typename DistributionType>
int RandomIntegerGenerator<EngineType, DistributionType>::rand() {
  return Distribution(Engine);
}

template<typename ElementType, typename GeneratorType>
RandomElementChooser<ElementType, GeneratorType>::
  RandomElementChooser(const std::vector<ElementType> &ListToChooseFrom)
: Generator(0, ListToChooseFrom.empty() ? 0 : ListToChooseFrom.size() - 1),
List(ListToChooseFrom) {
  assert(!ListToChooseFrom.empty() && "list of elements to choose from must "
                                      "not be empty");
};
  
template<typename ElementType, typename GeneratorType>
ElementType RandomElementChooser<ElementType, GeneratorType>::rand() {
  return List.at(Generator.rand());
}

template<typename ElementType, typename ChooserType>
RandomVectorGenerator<ElementType, ChooserType>::
  RandomVectorGenerator(const std::vector<ElementType> &ListToChooseFrom)
: Chooser(ListToChooseFrom) {}
  
template<typename ElementType, typename ChooserType>
std::vector<ElementType>
RandomVectorGenerator<ElementType, ChooserType>::
  rand(length_type<ElementType> Length) {
  std::vector<ElementType> Result;
  for (length_type<ElementType> i = 0; i < Length; i++) {
    Result.push_back(Chooser.rand());
  }
  return Result;
}

template<typename ChooserType>
RandomStringGenerator<ChooserType>::
  RandomStringGenerator(const std::vector<std::string> &ListToChooseFrom)
: Generator(ListToChooseFrom) {}

template<typename ChooserType>
std::string
RandomStringGenerator<ChooserType>::rand(length_type<std::string> Length) {
  auto Characters = Generator.rand(Length);
  std::stringstream Result;
  std::copy(Characters.cbegin(),
            Characters.cend(),
            std::ostream_iterator<std::string>(Result, ""));
  return Result.str();
}
  
}
}

#endif /* RandomTemplate_h */
