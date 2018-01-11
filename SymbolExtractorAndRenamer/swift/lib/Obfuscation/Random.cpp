#include "swift/Obfuscation/Random.h"

namespace swift {
namespace obfuscation {

int RandomIntegerGenerator::rand() {
  return Distribution(Engine);
}

template<typename T>
T RandomElementChooser<T>::rand() const {
  return List.at(Generator->rand());
}
  
template<typename T>
RandomElementChooser<T>::~RandomElementChooser() {
  delete Generator;
}

template std::string RandomElementChooser<std::string>::rand() const;
template std::string RandomElementChooser<std::string>::~RandomElementChooser();
  
template<typename T>
std::vector<T> RandomVectorGenerator<T>::rand(size_type Length) const {
  std::vector<T> Result;
  for (size_type i = 0; i < Length; i++) {
    Result.push_back(Chooser->rand());
  }
  return Result;
}

template<typename T>
RandomVectorGenerator<T>::~RandomVectorGenerator() {
  delete Chooser;
}

std::string RandomStringGenerator::rand(size_type Length) const {
  auto Vector = Generator->rand(Length);
  std::string Result;
  for (const auto &Elem : Vector) {
    Result += Elem;
  }
  return Result;
}
  
RandomStringGenerator::~RandomStringGenerator() {
  delete Generator;
}

} //namespace obfuscation
} //namespace swift
