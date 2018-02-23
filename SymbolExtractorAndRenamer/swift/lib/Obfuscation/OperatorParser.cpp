#include "swift/Obfuscation/OperatorParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

namespace swift {
namespace obfuscation {

SingleSymbolOrError parse(const OperatorDecl* Declaration) {

  auto ModuleNameAndParts = moduleNameAndIdentifierParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> IdentifierParts = ModuleNameAndParts.second;
  std::string SymbolName = symbolName(Declaration);
  IdentifierParts.push_back("operator." + SymbolName);

  return Symbol(combineIdentifier(IdentifierParts),
                SymbolName,
                ModuleName,
                SymbolType::Operator);
}

SymbolsOrError parseOperator(const FuncDecl* Declaration, CharSourceRange Range) {

  std::vector<SymbolWithRange> Symbols;

  // Creates the symbols for the parameters of the operator implementation
  auto ParametersSymbolsOrError =
    parseSeparateFunctionDeclarationForParameters(Declaration);
  if (auto Error = ParametersSymbolsOrError.takeError()) {
    return std::move(Error);
  }
  // Parameters for the operator implementation might be always renamed because
  // they are not part of the interface that the operator defines
  copyToVector(ParametersSymbolsOrError.get(), Symbols);

  // We don't rename the operator if the operator is from other module
  // than the operator's implementation
  if (auto OperatorDecl = Declaration->getOperatorDecl()) {
    auto OperatorModuleName = moduleName(OperatorDecl);
    if (moduleName(Declaration) != OperatorModuleName) {
      return Symbols;
    }
  }

  auto ModuleAndParts = moduleNameAndIdentifierParts(Declaration);
  auto ModuleName = ModuleAndParts.first;
  auto Parts = ModuleAndParts.second;

  auto SymbolName = declarationName(Declaration);
  Parts.push_back("operator." + SymbolName);

  Symbol Symbol(combineIdentifier(Parts),
                SymbolName,
                ModuleName,
                SymbolType::Operator);

  Symbols.push_back(SymbolWithRange(Symbol, Range));
  return Symbols;
}

} //namespace obfuscation
} //namespace swift
