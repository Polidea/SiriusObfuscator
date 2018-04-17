#ifndef Excluder_h
#define Excluder_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Extractor.h"

namespace swift {
namespace obfuscation {

class Excluder {

public:

virtual llvm::Optional<DeclWithSymbolWithRange>
symbolsToExclude(DeclWithSymbolWithRange &DeclAndSymbolWithRange) = 0;

virtual ~Excluder() = default;

};

class ConfigurationExcluder: public Excluder {

private:

  ObfuscationConfiguration Configuration;
  NominalTypeExtractor &NominalTypeExtractor;

  bool shouldExclude(Decl *Declaration,
                     const std::pair<const ClassDecl *,
                     std::string> &DeclarationAndModule,
                     const InheritanceExclusion *ExcludedType);

  bool handleTypeExclusion(const TypeExclusion *Exclusion, Decl *Declaration);

  bool handleInheritanceExclusion(const InheritanceExclusion *Exclusion,
                                  Decl *Declaration);

  bool handleConformanceExclusion(const ConformanceExclusion *Exclusion,
                                  Decl *Declaration);

public:

  ConfigurationExcluder(ObfuscationConfiguration &&,
                        class NominalTypeExtractor &);

  llvm::Optional<DeclWithSymbolWithRange>
  symbolsToExclude(DeclWithSymbolWithRange &DeclAndSymbolWithRange) override;

};

class NSManagedExcluder: public Excluder {

public:

  llvm::Optional<DeclWithSymbolWithRange>
  symbolsToExclude(DeclWithSymbolWithRange &DeclAndSymbolWithRange) override;

};

} //namespace obfuscation
} //namespace swift

#endif /* Excluder_h */
