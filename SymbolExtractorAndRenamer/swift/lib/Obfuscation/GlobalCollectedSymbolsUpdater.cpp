#include "swift/Obfuscation/GlobalCollectedSymbolsUpdater.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

GlobalCollectedSymbolsUpdater::~GlobalCollectedSymbolsUpdater() = default;

void ExcludedSymbolsUpdater::
  load(std::vector<DeclWithSymbolWithRange> &Declarations) {
  for (auto &Declaration : Declarations) {
    LoadedSymbols.push_back(Declaration);
  }
}

void ExcludedSymbolsUpdater::
  updateUsingLoadedSymbols(GlobalCollectedSymbols &Symbols) {

  std::vector<IndexedDeclWithSymbolWithRange> SymbolsToRemove;

  for (auto &ExcludedSymbol : LoadedSymbols) {
    for (auto &Symbol : Symbols) {
      if (ExcludedSymbol.Symbol.Identifier == Symbol.Symbol.Identifier) {
        SymbolsToRemove.push_back(Symbol);
      }
    }
  }

  for (auto IndexedSymbolWithRange : SymbolsToRemove) {
    Symbols.erase(IndexedSymbolWithRange);
  }
}

GlobalCollectedSymbolsUpdaterKind ExcludedSymbolsUpdater::getKind() {
  return GlobalCollectedSymbolsUpdaterKind::ExcludedSymbols;
}

ProtocolFunctionUpdater::
  ProtocolFunctionUpdater(FunctionExtractor &FuncExtractor,
                          ParameterExtractor &ParamExtractor)
: FuncExtractor(FuncExtractor), ParamExtractor(ParamExtractor) {}

void ProtocolFunctionUpdater::
  load(std::vector<DeclWithSymbolWithRange> &Declarations) {
    for (auto &Declaration : Declarations) {
      if (dyn_cast<FuncDecl>(Declaration.Declaration)) {
        LoadedSymbols.push_back(Declaration);
      } else if (dyn_cast<ParamDecl>(Declaration.Declaration)) {
        LoadedSymbols.push_back(Declaration);
      }
    }
}

void ProtocolFunctionUpdater::
handleRequirement(const ValueDecl* Requirement,
                  GlobalCollectedSymbols &CollectedSymbols,
                  SymbolWithRange FunctionNameSymbol,
                  const FuncDecl* Declaration) {

  if (auto *ProtocolFun = dyn_cast<FuncDecl>(Requirement)) {
    auto ModuleAndParts = FuncExtractor.functionIdentifierParts(ProtocolFun);
    auto Parts = ModuleAndParts.second;
    auto ProtocolFunId = combineIdentifier(Parts);

    // TODO: what about implicit? should we check for them?
    // Create the symbols for protocol function parameters
    auto ProtocolFunParametersSymbols =
      ParamExtractor.parametersFrom(ProtocolFun);

    // Create the symbols for overridden function parameters
    auto OverriddenFunParametersSymbols =
      ParamExtractor.parametersFrom(Declaration);

    // Parameter count for both protocol method and overridden method
    // must be the same, otherwise we don't know what to do with them.
    if (OverriddenFunParametersSymbols.size()
        != ProtocolFunParametersSymbols.size()) {
      return;
    }

    // rename protocol method symbol id

    // find protocol function identifier in a set of all collected symbols
    // and replace it with function identifier of overridden symbol
    for (auto CollectedSymbol: CollectedSymbols) {
      if (CollectedSymbol.Symbol.Identifier == ProtocolFunId) {

        CollectedSymbols.erase(CollectedSymbol);
        CollectedSymbol.Symbol.Identifier =
          FunctionNameSymbol.Symbol.Identifier;
        CollectedSymbols.insert(CollectedSymbol);
        break;
      }
    }

    // rename protocol method parameters symbol ids
    for(size_t i = 0; i < ProtocolFunParametersSymbols.size(); i++) {
      auto ProtocolFunParameter = ProtocolFunParametersSymbols[i];

      // find protocol parameter identifier in a set of all collected symbols
      // and replace it with parameter identifier of overridden symbol
      for (auto CollectedSymbol: CollectedSymbols) {
        if (CollectedSymbol.Declaration == ProtocolFunParameter.Declaration
            && CollectedSymbol.Symbol.Type != SymbolType::InternalParameter) {
          size_t Index = CollectedSymbol.Symbol.Identifier.find(ProtocolFunId);
          if (Index != std::string::npos) {
            CollectedSymbols.erase(CollectedSymbol);
            CollectedSymbol.Symbol.Identifier.replace(Index,
                                                      ProtocolFunId.size(),
                                                      FunctionNameSymbol.Symbol.Identifier);
            CollectedSymbols.insert(CollectedSymbol);
          }
          break;
        }
      }
    }
  }
}

void ProtocolFunctionUpdater::
  updateUsingLoadedSymbols(GlobalCollectedSymbols &Symbols) {

  for (auto &Declaration : LoadedSymbols) {

    if (auto *Function = dyn_cast<FuncDecl>(Declaration.Declaration)) {
      //check if this overridden method is also satisfying some protocol
      auto ProtocolRequirements =
        FuncExtractor.satisfiedProtocolRequirements(Function);
      auto SatisfiesProtocol = !ProtocolRequirements.empty();

      // we assume that there is always only one overriden symbol
      if (SatisfiesProtocol) {
        for (auto Requirement : ProtocolRequirements) {
          handleRequirement(Requirement,
                            Symbols,
                            SymbolWithRange(Declaration.Symbol, Declaration.Range),
                            Function);
        }
      }
    }
  }
}

GlobalCollectedSymbolsUpdaterKind ProtocolFunctionUpdater::getKind() {
  return GlobalCollectedSymbolsUpdaterKind::ProtocolFunction;
}

ExtensionSymbolsUpdater::
  ExtensionSymbolsUpdater(FunctionExtractor &FuncExtractor,
                          ParameterExtractor &ParamExtractor)
: FuncExtractor(FuncExtractor), ParamExtractor(ParamExtractor) {}

void ExtensionSymbolsUpdater::load(std::vector<DeclWithSymbolWithRange> &Declarations) {

  for (auto DeclAndSymbolWithRange : Declarations) {

    auto *Declaration = DeclAndSymbolWithRange.Declaration;

    if (auto *NominalType = dyn_cast<NominalTypeDecl>(Declaration)) {

      for (auto *Extension : NominalType->getExtensions()) {

        if (auto ExtensionDeclaration = dyn_cast<ExtensionDecl>(Extension)) {

          std::vector<SymbolWithRange> Results;
          auto *ExtendedType = ExtensionDeclaration->getExtendedType()->getAnyNominal();
          auto ExtensionModuleName = FuncExtractor.moduleName(ExtensionDeclaration);
          if (ExtendedType == nullptr) {
            continue;
          }

          auto ExtendedTypeModuleName = FuncExtractor.moduleName(ExtendedType);
          if (ExtensionModuleName == ExtendedTypeModuleName) {
            continue;
          }

          if (!ExtensionDeclaration->getMembers().empty()) {
            continue;
          }

          auto InheritedArray = ExtensionDeclaration->getInherited();

          for (auto Inherited : InheritedArray) {

            auto *Nominal = Inherited.getType()->getAnyNominal();
            if (auto *ProtocolDeclaration = dyn_cast_or_null<ProtocolDecl>(Nominal)) {
              for (auto *Member : ProtocolDeclaration->getMembers()) {
                for (auto *Declaration : ExtendedType->getMembers()) {

                  if (auto *ExtFunction = dyn_cast<AbstractFunctionDecl>(Declaration)) {
                    if (auto *ProtocolFunction =
                        dyn_cast<AbstractFunctionDecl>(Member)) {

                      auto ExtFunctionSignature =
                        FuncExtractor.functionSignature(ExtFunction);
                      auto ProtocolFunctionSignature =
                        FuncExtractor.functionSignature(ProtocolFunction);
                      auto ExtFunctionName = ExtFunction->getName().str().str();
                      auto ProtocolFunctionName =
                      ProtocolFunction->getName().str().str();

                      if (ExtFunctionSignature == ProtocolFunctionSignature
                          && ExtFunctionName == ProtocolFunctionName) {
                        LoadedSymbols.push_back(DeclWithSymbolWithRange(Member,
                                                                        DeclAndSymbolWithRange.Symbol,
                                                                        DeclAndSymbolWithRange.Range));

                        for (auto &ExtFunctionParam :
                              ParamExtractor.parametersFrom(ProtocolFunction)) {
                          LoadedSymbols.push_back(DeclWithSymbolWithRange(ExtFunctionParam.Declaration,
                                                                          DeclAndSymbolWithRange.Symbol,
                                                                          DeclAndSymbolWithRange.Range));
                        }
                      }
                    }
                  }

                  if (auto *ExtFunction = dyn_cast<AbstractStorageDecl>(Declaration)) {
                    if (auto *ProtocolFunction =
                        dyn_cast<AbstractStorageDecl>(Member)) {

                      auto ExtFunctionSignature =
                      ExtFunction->getInterfaceType().getString();
                      auto ProtocolFunctionSignature =
                      ProtocolFunction->getInterfaceType().getString();
                      auto ExtFunctionName = ExtFunction->getName().str().str();
                      auto ProtocolFunctionName =
                      ProtocolFunction->getName().str().str();

                      if (ExtFunctionSignature == ProtocolFunctionSignature
                          && ExtFunctionName == ProtocolFunctionName) {
                        LoadedSymbols.push_back(DeclWithSymbolWithRange(Member,
                                                                        DeclAndSymbolWithRange.Symbol,
                                                                        DeclAndSymbolWithRange.Range));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void ExtensionSymbolsUpdater::updateUsingLoadedSymbols(GlobalCollectedSymbols &Symbols) {

  std::vector<IndexedDeclWithSymbolWithRange> SymbolsToRemove;

  for (auto &ExcludedSymbol : LoadedSymbols) {
    for (auto &Symbol : Symbols) {
      if (Symbol.Declaration == ExcludedSymbol.Declaration) {
        SymbolsToRemove.push_back(Symbol);
      }
    }
  }

  for (auto IndexedSymbolWithRange : SymbolsToRemove) {
    Symbols.erase(IndexedSymbolWithRange);
  }
}

GlobalCollectedSymbolsUpdaterKind ExtensionSymbolsUpdater::getKind() {
  return GlobalCollectedSymbolsUpdaterKind::ExtensionSymbols;
}

} //namespace obfuscation
} //namespace swift
