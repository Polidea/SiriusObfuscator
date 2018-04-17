#ifndef Updater_h
#define Updater_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Extractor.h"

namespace swift {
namespace obfuscation {

enum GlobalCollectedSymbolsUpdaterKind {
  ProtocolFunction,
  ExcludedSymbols,
  ExtensionSymbols
};

class GlobalCollectedSymbolsUpdater {

protected:

  std::vector<DeclWithSymbolWithRange> LoadedSymbols;

public:

  virtual ~GlobalCollectedSymbolsUpdater() = 0;

  virtual void load(std::vector<DeclWithSymbolWithRange> &) = 0;

  virtual void updateUsingLoadedSymbols(GlobalCollectedSymbols &) = 0;

  virtual GlobalCollectedSymbolsUpdaterKind getKind() = 0;

};

class ProtocolFunctionUpdater : public GlobalCollectedSymbolsUpdater {

private:

  FunctionExtractor FuncExtractor;
  ParameterExtractor ParamExtractor;

  void
  handleRequirement(const ValueDecl* Requirement,
                    GlobalCollectedSymbols &CollectedSymbols,
                    SymbolWithRange FunctionNameSymbol,
                    const FuncDecl* Declaration);

  void 
  handleSatisfiedProtocolRequirements(GlobalCollectedSymbols &CollectedSymbols,
                                      SymbolWithRange FunctionNameSymbol,
                                      const FuncDecl* Declaration);

public:

  ProtocolFunctionUpdater(FunctionExtractor &, ParameterExtractor &);

  void load(std::vector<DeclWithSymbolWithRange> &) override;

  void updateUsingLoadedSymbols(GlobalCollectedSymbols &) override;

  GlobalCollectedSymbolsUpdaterKind getKind() override;

};

class ExcludedSymbolsUpdater : public GlobalCollectedSymbolsUpdater {

public:

  void load(std::vector<DeclWithSymbolWithRange> &) override;

  void updateUsingLoadedSymbols(GlobalCollectedSymbols &) override;

  GlobalCollectedSymbolsUpdaterKind getKind() override;

};

class ExtensionSymbolsUpdater : public GlobalCollectedSymbolsUpdater {

private:

  FunctionExtractor FuncExtractor;
  ParameterExtractor ParamExtractor;

public:

  ExtensionSymbolsUpdater(FunctionExtractor &, ParameterExtractor &);

  void load(std::vector<DeclWithSymbolWithRange> &) override;

  void updateUsingLoadedSymbols(GlobalCollectedSymbols &) override;

  GlobalCollectedSymbolsUpdaterKind getKind() override;

};

} //namespace obfuscation
} //namespace swift

#endif /* Updater_h */
