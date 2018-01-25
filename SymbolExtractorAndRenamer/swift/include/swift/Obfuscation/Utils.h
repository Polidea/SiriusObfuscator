#ifndef Utils_h
#define Utils_h

#include "llvm/Support/Error.h"

#include <set>
#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

/// A factory function for creating the llvm::Error object.
///
/// The returned object has the llvm::StringError type.
/// Its message is set to \p Message.
/// It is transformable to std::error of value given in \p Error.
///
/// Typical usage:
/// \code
/// return stringError("couldn't generate unique type name");
/// \endcode
///
/// \param Message Message to be included in llvm::StringError.
/// \param Error Standard error_code that the resulting llvm::Error
///        object will be transformable to. It's an optional parameter.
///        If ommited, it's the generic category error code 1.
///
/// \returns the constructed llvm::Error object.
llvm::Error stringError(const std::string Message,
                        const std::error_code Error =
                          std::error_code(1, std::generic_category()));

template<typename ElementType>
void copyToVector(const std::vector<ElementType> &FromVector,
                  std::vector<ElementType> &ToVector);
  
template<typename ElementType>
void copyToVector(const std::set<ElementType> &FromSet,
                  std::vector<ElementType> &ToVector);
  
template<typename ElementType>
void copyToStream(const std::vector<ElementType> &FromVector,
                  std::ostream_iterator<ElementType> Inserter);

} //namespace obfuscation
} //namespace swift

#include "swift/Obfuscation/Utils-Template.h"

#endif /* Utils_h */
