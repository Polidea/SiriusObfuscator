#include "swift/Obfuscation/ConfigurationExcluder.h"

namespace swift {
namespace obfuscation {

ConfigurationExcluder::
  ConfigurationExcluder(ObfuscationConfiguration&& Configuration)
: Configuration(std::move(Configuration)) {

  // TODO: remove when there's logic added to identifyExclusions method
  for (auto &Exclusion : this->Configuration.Exclude) {
    switch (Exclusion->Kind) {
      case ExclusionKind::Type: {
        auto Type = Exclusion->getAsTypeExclusion();
        llvm::outs() << Type->Name << '\n';
        break;
      }
      case ExclusionKind::Inheritance: {
        auto Type = Exclusion->getAsInheritanceExclusion();
        llvm::outs() << Type->Base << '\n';
        break;
      }
      case ExclusionKind::Conformance: {
        auto Type = Exclusion->getAsConformanceExclusion();
        llvm::outs() << Type->Protocol << '\n';
        break;
      }
    }
  }

}

void ConfigurationExcluder::identifyExclusions(Decl *Declaration) {

}

} // namespace obfuscation
} // namespace swift
