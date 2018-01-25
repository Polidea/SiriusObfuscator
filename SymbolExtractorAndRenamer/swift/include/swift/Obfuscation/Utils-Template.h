#ifndef Utils_Template_h
#define Utils_Template_h

namespace swift {
namespace obfuscation {

template<typename ElementType>
void copyToVector(const std::vector<ElementType> &FromVector,
                  std::vector<ElementType> &ToVector) {
  std::copy(FromVector.cbegin(),
            FromVector.cend(),
            std::back_inserter(ToVector));
};
  
template<typename ElementType>
void copyToVector(const std::set<ElementType> &FromSet,
                  std::vector<ElementType> &ToVector) {
  std::copy(FromSet.cbegin(),
            FromSet.cend(),
            std::back_inserter(ToVector));
};
  
template<typename ElementType>
void copyToStream(const std::vector<ElementType> &FromVector,
          std::ostream_iterator<ElementType> Inserter) {
  std::copy(FromVector.cbegin(),
            FromVector.cend(),
            Inserter);
};

} //namespace obfuscation
} //namespace swift

#endif /* Utils_Template_h */
