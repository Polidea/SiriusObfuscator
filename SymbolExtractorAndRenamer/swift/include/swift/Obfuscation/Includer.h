#ifndef Includer_h
#define Includer_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Extractor.h"

#include <vector>

namespace swift {
namespace obfuscation {

class Includer {

public:

  virtual ~Includer() = 0;

  virtual DeclsWithRangesOrErrors include(DeclWithRange &) = 0;

};

class NominalTypeIncluder : public Includer {

public:

  DeclsWithRangesOrErrors include(DeclWithRange &) override;

};

class FunctionNameIncluder : public Includer {

public:

  DeclsWithRangesOrErrors include(DeclWithRange &) override;

};

class OperatorIncluder : public Includer {

  OperatorExtractor Extractor;

public:

  OperatorIncluder(OperatorExtractor &);

  DeclsWithRangesOrErrors include(DeclWithRange &) override;

};

class FunctionParametersIncluder : public Includer {

private:

  ParameterExtractor Extractor;

public:

  FunctionParametersIncluder(ParameterExtractor &);

  DeclsWithRangesOrErrors include(DeclWithRange &) override;

};

class VariableIncluder : public Includer {

private:

  VariableExtractor Extractor;

public:

  VariableIncluder(VariableExtractor &);

  DeclsWithRangesOrErrors include(DeclWithRange &) override;

};

} //namespace obfuscation
} //namespace swift

#endif /* Includer_h */
