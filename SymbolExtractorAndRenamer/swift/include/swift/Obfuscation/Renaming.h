#ifndef Renaming_h
#define Renaming_h

#include "swift/Obfuscation/DataStructures.h"

#include "llvm/Support/Error.h"

#include <vector>
#include <string>
#include <utility>

namespace swift {
namespace obfuscation {

using FilesList = std::vector<std::pair<std::string, std::string>>;

llvm::Expected<FilesList> performRenaming(std::string MainExecutablePath,
                                          const FilesJson &FilesJson,
                                          const RenamesJson &RenamesJson,
                                          std::string ObfuscatedProjectPath);

} //namespace obfuscation
} //namespace swift

#endif /* Renaming_h */
