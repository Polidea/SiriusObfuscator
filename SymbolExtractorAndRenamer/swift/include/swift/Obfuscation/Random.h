#ifndef Random_h
#define Random_h

#include <vector>
#include <string>
#include <random>

namespace swift {
namespace obfuscation {

class RandomIntegerGenerator {
  
private:
  
  std::random_device RandomDevice;
  std::mt19937 Engine;
  std::uniform_int_distribution<int> Distribution;
  
public:
  
  RandomIntegerGenerator(int Min, int Max)
  : RandomDevice(),
  Engine(RandomDevice()),
  Distribution(std::uniform_int_distribution<int>(Min, Max)) {}
  
  int rand();

};

template<typename T>
class RandomElementChooser {
  
private:
  
  RandomIntegerGenerator* Generator;
  std::vector<T> List;
  
public:
  
  RandomElementChooser(const std::vector<T> &ListToChooseFrom) :
  Generator(new RandomIntegerGenerator(0, ListToChooseFrom.size() - 1)),
  List(ListToChooseFrom) {}
  
  T rand() const;
  
  ~RandomElementChooser();

};

template<typename T>
class RandomVectorGenerator {
  
private:
  
  RandomElementChooser<T>* Chooser;
  
public:
  
  RandomVectorGenerator(const std::vector<T> &ListToChooseFrom) :
  Chooser(new RandomElementChooser<T>(ListToChooseFrom)) {}
  
  typedef typename std::vector<T>::size_type size_type;
  
  std::vector<T> rand(size_type Length) const;
  
  ~RandomVectorGenerator();

};

class RandomStringGenerator {
  
private:
  
  RandomVectorGenerator<std::string>* Generator;
  
public:
  
  typedef std::vector<std::string>::size_type size_type;
  
  RandomStringGenerator(const std::vector<std::string> &ListToChooseFrom)
  : Generator(new RandomVectorGenerator<std::string>(ListToChooseFrom)) {}
  
  std::string rand(size_type Length) const;
  
  ~RandomStringGenerator();

};

} //namespace obfuscation
} //namespace swift

#endif /* Random_h */
