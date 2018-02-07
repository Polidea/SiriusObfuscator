#include "swift/Obfuscation/OperatorParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {

using SingleSymbolOrError = llvm::Expected<Symbol>;

SingleSymbolOrError parse(const OperatorDecl* Declaration) {

  auto ModuleNameAndParts = moduleNameAndParts(Declaration);
  std::string ModuleName = ModuleNameAndParts.first;
  std::vector<std::string> Parts = ModuleNameAndParts.second;
  std::string SymbolName = Declaration->getName().str().str();
  Parts.push_back("operator." + SymbolName);

  return Symbol(combineIdentifier(Parts),
                SymbolName,
                ModuleName,
                SymbolType::Operator);
}

SymbolsOrError parseOperator(const FuncDecl* Declaration, CharSourceRange Range) {

    std::vector<SymbolWithRange> Symbols;

    auto ParametersSymbolsOrError =
    parseSeparateFunctionDeclarationForParameters(Declaration);
    if (auto Error = ParametersSymbolsOrError.takeError()) {
        return std::move(Error);
    }
    copyToVector(ParametersSymbolsOrError.get(), Symbols);

    if (auto OperatorDecl = Declaration->getOperatorDecl()) {
        auto OperatorModuleName = moduleName(OperatorDecl);
        if (moduleName(Declaration) != OperatorModuleName) {
            return Symbols;
        }
    }
  
    auto ModuleAndParts = functionIdentifierParts(Declaration);
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
