#include "swift/Obfuscation/ExtensionExcluder.h"
#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/NominalTypeDeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"

namespace swift {
namespace obfuscation {

void
ExtensionExcluder::
  identifyExclusionsFromExtension(const ExtensionDecl *Declaration) {

  std::vector<SymbolWithRange> Results;
  auto *ExtendedType = Declaration->getExtendedType()->getAnyNominal();
  auto ExtensionModuleName = moduleName(Declaration);
  if (ExtendedType == nullptr) {
    return;
  }

  auto ExtendedTypeModuleName = moduleName(ExtendedType);
  if (ExtensionModuleName == ExtendedTypeModuleName) {
    return;
  }

  if (!Declaration->getMembers().empty()) {
    return;
  }

  auto InheritedArray = Declaration->getInherited();

  for (auto Inherited : InheritedArray) {

    auto *Nominal = Inherited.getType()->getAnyNominal();
    if (auto *ProtocolDeclaration = dyn_cast_or_null<ProtocolDecl>(Nominal)) {
      for (auto *Member : ProtocolDeclaration->getMembers()) {
        Member->getSourceRange();
        for (auto *Declaration : ExtendedType->getMembers()) {

          if (auto *ExtFunction = dyn_cast<AbstractFunctionDecl>(Declaration)) {
            if (auto *ProtocolFunction =
                  dyn_cast<AbstractFunctionDecl>(Member)) {

              auto ExtFunctionSignature = functionSignature(ExtFunction);
              auto ProtocolFunctionSignature =
                functionSignature(ProtocolFunction);
              auto ExtFunctionName = ExtFunction->getName().str().str();
              auto ProtocolFunctionName =
                ProtocolFunction->getName().str().str();

              if (ExtFunctionSignature == ProtocolFunctionSignature
                  && ExtFunctionName == ProtocolFunctionName) {
                DeclarationsToExclude.insert(Member);
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
                DeclarationsToExclude.insert(Member);
              }
            }
          }
        }
      }
    }
  }
}

std::vector<IndexedSymbolWithRange>
ExtensionExcluder::
  excludeSymbolsFrom(GlobalCollectedSymbols &CollectedSymbols) {

  std::vector<IndexedSymbolWithRange> SymbolsToRemove;

  for (auto *Declaration : DeclarationsToExclude) {

    auto Range = CharSourceRange();
    auto SymbolsOrError = extractSymbol(CollectedSymbols, Declaration, Range);
    if (auto Error = SymbolsOrError.takeError()) {
      llvm::consumeError(std::move(Error));
    } else {
      auto Symbols = SymbolsOrError.get();
      for (auto CollectedSymbol : CollectedSymbols) {
        for (auto Symbol : Symbols) {
          if(CollectedSymbol.SymbolWithRange.Symbol.Identifier
             == Symbol.Symbol.Identifier) {
            SymbolsToRemove.push_back(CollectedSymbol);
          }
        }
      }
    }

  }

  for (auto IndexedSymbolWithRange : SymbolsToRemove) {
    CollectedSymbols.erase(IndexedSymbolWithRange);
  }

  return SymbolsToRemove;
}

} //namespace obfuscation
} //namespace swift
