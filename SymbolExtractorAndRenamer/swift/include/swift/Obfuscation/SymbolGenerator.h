#ifndef SymbolGenerator_h
#define SymbolGenerator_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Extractor.h"

#include <vector>

namespace swift {
namespace obfuscation {

class SymbolGenerator {

public:

  virtual ~SymbolGenerator() = 0;

  virtual DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) = 0;

};

class NominalTypeSymbolGenerator : public SymbolGenerator {

private:

  NominalTypeExtractor Extractor;

public:

  NominalTypeSymbolGenerator(NominalTypeExtractor &);

  DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) override;

};

class FunctionNameSymbolGenerator : public SymbolGenerator {

private:

  FunctionExtractor Extractor;

  SymbolWithRange getFunctionSymbol(const swift::FuncDecl *Declaration,
                                    const swift::CharSourceRange &Range);

  llvm::Expected<SymbolWithRange>
  parseOverridenDeclaration(const FuncDecl *Declaration,
                            const std::string &ModuleName,
                            const CharSourceRange &Range);

public:

  FunctionNameSymbolGenerator(FunctionExtractor &);

  DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) override;

  

};

class OperatorSymbolGenerator : public SymbolGenerator {

private:

  OperatorExtractor Extractor;

public:

  OperatorSymbolGenerator(OperatorExtractor &);

  DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) override;

};

class FunctionParameterSymbolGenerator : public SymbolGenerator {

private:

  FunctionExtractor FuncExtractor;
  ParameterExtractor ParamExtractor;

  llvm::Expected<std::string>
  getIdentifierWithParameterPosition(const ParamDecl *,
                                     const AbstractFunctionDecl *);

public:

  FunctionParameterSymbolGenerator(FunctionExtractor &, ParameterExtractor &);

  DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) override;

};

class VariableSymbolGenerator : public SymbolGenerator {

private:

  VariableExtractor Extractor;

  SingleSymbolOrError parseOverridenDeclaration(const VarDecl *Declaration,
                                                const std::string &ModuleName);

public:

  VariableSymbolGenerator(VariableExtractor &);

  DeclsWithSymbolsWithRangesOrErrors generateFor(DeclWithRange &) override;

};

} //namespace obfuscation
} //namespace swift

#endif /* SymbolGenerator_h */
