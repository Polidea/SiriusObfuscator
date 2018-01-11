#ifndef CompilerInfrastructure_h
#define CompilerInfrastructure_h

#include "llvm/Support/Error.h"
#include "swift/Frontend/Frontend.h"
#include "swift/Obfuscation/DataStructures.h"

#include <string>

namespace swift {
namespace obfuscation {

llvm::Error
setupCompilerInstance(CompilerInstance &CompilerInstance,
                      const FilesJson &FilesJson,
                      std::string MainExecutablePath);
  
} //namespace obfuscation
} //namespace swift

#endif /* CompilerInfrastructure_h */
