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
  
template<typename ElementType, typename CompareFrom>
void copyToVector(const std::set<ElementType, CompareFrom> &FromSet,
                  std::vector<ElementType> &ToVector) {
  std::copy(FromSet.cbegin(),
            FromSet.cend(),
            std::back_inserter(ToVector));
};

template<typename ElementType, typename CompareFrom, typename CompareTo>
void copyToSet(const std::set<ElementType, CompareFrom> &FromSet,
               std::set<ElementType, CompareTo> &ToSet) {
  std::copy(FromSet.cbegin(),
            FromSet.cend(),
            std::inserter(ToSet, ToSet.begin()));
};

template<typename ElementType, typename CompareTo>
void copyToSet(const std::vector<ElementType> &FromVector,
               std::set<ElementType, CompareTo> &ToSet) {
  std::copy(FromVector.cbegin(),
            FromVector.cend(),
            std::inserter(ToSet, ToSet.begin()));
}

template<typename ElementType>
void copyToStream(const std::vector<ElementType> &FromVector,
          std::ostream_iterator<ElementType> Inserter) {
  std::copy(FromVector.cbegin(),
            FromVector.cend(),
            Inserter);
};

template<typename T>
void removeFromVector(std::vector<T> &FromVector, const T &Element) {
  FromVector.erase(std::remove(FromVector.begin(), FromVector.end(), Element),
                   FromVector.end());
};

} //namespace obfuscation
} //namespace swift

#endif /* Utils_Template_h */
