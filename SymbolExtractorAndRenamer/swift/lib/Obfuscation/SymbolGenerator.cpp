#include "swift/Obfuscation/SymbolGenerator.h"
#include "swift/Obfuscation/Utils.h"

#include <sstream>

namespace swift {
namespace obfuscation {

SymbolGenerator::~SymbolGenerator() = default;

NominalTypeSymbolGenerator::
  NominalTypeSymbolGenerator(NominalTypeExtractor &Extractor)
: Extractor(Extractor) {}

std::vector<llvm::Expected<DeclWithSymbolWithRange>>
NominalTypeSymbolGenerator::generateFor(DeclWithRange &DeclAndRange) {

  if (auto *Declaration = dyn_cast<NominalTypeDecl>(DeclAndRange.Declaration)) {

    auto ModuleNameAndParts = Extractor.moduleNameAndIdentifierParts(Declaration);

    std::string ModuleName = ModuleNameAndParts.first;
    std::vector<std::string> IdentifierParts = ModuleNameAndParts.second;
    std::string SymbolName = Extractor.symbolName(Declaration);

    auto NominalTypeParts =
      Extractor.nominalTypeIdentifierParts(Declaration, Extractor.typeName(Declaration));
    if (auto Error = NominalTypeParts.takeError()) {
      return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
    }
    copyToVector(NominalTypeParts.get(), IdentifierParts);

    Symbol Symbol(combineIdentifier(IdentifierParts),
                  SymbolName,
                  ModuleName,
                  SymbolType::Type);

    return wrapInVector(DeclWithSymbolWithRange(DeclAndRange, Symbol));
  }

  auto Error = stringError("NominalTypeSymbolGenerator cannot generate symbol "
                           "for non-NominalTypeDecl Declaration");
  return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
}

FunctionNameSymbolGenerator::FunctionNameSymbolGenerator(FunctionExtractor &Extractor)
: Extractor(Extractor) {}

SymbolWithRange
FunctionNameSymbolGenerator::getFunctionSymbol(const swift::FuncDecl *Declaration,
                                           const swift::CharSourceRange &Range) {
  auto ModuleAndParts = Extractor.functionIdentifierParts(Declaration);
  auto ModuleName = ModuleAndParts.first;
  auto Parts = ModuleAndParts.second;
  Symbol Symbol(combineIdentifier(Parts),
                Extractor.declarationName(Declaration),
                ModuleName,
                SymbolType::NamedFunction);
  return SymbolWithRange(Symbol, Range);
}

llvm::Expected<SymbolWithRange>
FunctionNameSymbolGenerator::parseOverridenDeclaration(const FuncDecl *Declaration,
                                                   const std::string &ModuleName,
                                                   const CharSourceRange &Range) {

  auto BaseWithModules =
    Extractor.getBaseOverridenDeclarationWithModules(Declaration);
  auto Base = BaseWithModules.first;
  auto Modules = BaseWithModules.second;

  // Emits symbol only if the base overriden function and
  // all the functions overriding it in the inheritance hierarchy are from
  // the same module and it's the module we've passed as ModuleName parameter.
  // Emitted symbol represents the base function so that all the functions that
  // override it are renamed to the same obfuscated name
  if (Extractor.isOverriddenMethodFromTheSameModule(Modules, ModuleName)) {
    return getFunctionSymbol(Base, Range);
  } else {
    // TODO: move it to includer, it should be checked there
    return stringError("only method overriding methods from the same module "
                       "might be safely obfuscated");
  }
}

DeclsWithSymbolsWithRangesOrErrors
FunctionNameSymbolGenerator::generateFor(DeclWithRange &DeclAndRange) {

  if (auto *Declaration = dyn_cast<FuncDecl>(DeclAndRange.Declaration)) {

    // function name should be renamed only if it's not a setter
    if(!Declaration->isSetter()) {

      // Create the symbol for function
      if (Declaration->getOverriddenDecl() != nullptr) {
        // Overriden declaration must be treated separately because we mustn't
        // rename function that overrides function from different module
        auto SymbolOrError =
          parseOverridenDeclaration(Declaration,
                                    Extractor.moduleName(Declaration),
                                    DeclAndRange.Range);
        if (auto Error = SymbolOrError.takeError()) {
          return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
        }
        auto FunctionNameSymbol = SymbolOrError.get();
        return wrapInVector(DeclWithSymbolWithRange(Declaration,
                                                    FunctionNameSymbol));
      } else {
        auto Symbol = getFunctionSymbol(Declaration, DeclAndRange.Range);
        return wrapInVector(DeclWithSymbolWithRange(Declaration, Symbol));
      }
    }
  }

  auto Error = stringError("FunctionNameSymbolGenerator cannot generate symbol "
                           "for non-FuncDecl Declaration");
  return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
}

OperatorSymbolGenerator::OperatorSymbolGenerator(OperatorExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithSymbolsWithRangesOrErrors
OperatorSymbolGenerator::generateFor(DeclWithRange &DeclAndRange) {

  if (auto *Declaration = dyn_cast<OperatorDecl>(DeclAndRange.Declaration)) {

    auto ModuleNameAndParts = Extractor.moduleNameAndIdentifierParts(Declaration);
    std::string ModuleName = ModuleNameAndParts.first;
    std::vector<std::string> IdentifierParts = ModuleNameAndParts.second;
    std::string SymbolName = Extractor.operatorName(Declaration);
    IdentifierParts.push_back("operator." + SymbolName);

    Symbol Symbol(combineIdentifier(IdentifierParts),
                  SymbolName,
                  ModuleName,
                  SymbolType::Operator);
    return wrapInVector(DeclWithSymbolWithRange(DeclAndRange, Symbol));

  } else if (auto *Declaration = dyn_cast<FuncDecl>(DeclAndRange.Declaration)) {

    std::vector<SymbolWithRange> Symbols;
    
    auto ModuleAndParts = Extractor.moduleNameAndIdentifierParts(Declaration);
    auto ModuleName = ModuleAndParts.first;
    auto Parts = ModuleAndParts.second;

    auto SymbolName = Extractor.declarationName(Declaration);
    Parts.push_back("operator." + SymbolName);

    Symbol Symbol(combineIdentifier(Parts),
                  SymbolName,
                  ModuleName,
                  SymbolType::Operator);
    return wrapInVector(DeclWithSymbolWithRange(DeclAndRange, Symbol));
  }
  auto Error = stringError("OperatorSymbolGenerator cannot generate symbol "
                           "for non-OperatorDecl Declaration");
  return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
}

FunctionParameterSymbolGenerator::
  FunctionParameterSymbolGenerator(FunctionExtractor &FuncExtractor,
                             ParameterExtractor &ParamExtractor)
: FuncExtractor(FuncExtractor), ParamExtractor(ParamExtractor) {}

llvm::Expected<std::string>
FunctionParameterSymbolGenerator::
  getIdentifierWithParameterPosition(const ParamDecl *Declaration,
                                     const AbstractFunctionDecl *FunctionDeclaration) {

  auto ParameterLists = FunctionDeclaration->getParameterLists();

  // We use index, not iterator, because we want to use the index
  // to build identifier
  for (unsigned ListIndex = 0; ListIndex < ParameterLists.size(); ++ListIndex) {

    auto *ParameterList = ParameterLists[ListIndex];

    // We use index, not iterator, because we want to use the index
    // to build identifier
    for (unsigned ParameterIndex = 0;
         ParameterIndex < ParameterList->size();
         ++ParameterIndex) {

      auto *ParamDeclaration = ParameterList->get(ParameterIndex);

      //this comparison may be wrong but I couldn't come up
      //with a sample code that breaks it
      if (Declaration->getName() == ParamDeclaration->getName()) {
        return "list" + std::to_string(ListIndex) +
        "_parameter" + std::to_string(ParameterIndex);
      }
    }
  }

  return stringError("Couldn't find parameter position");
}

DeclsWithSymbolsWithRangesOrErrors
FunctionParameterSymbolGenerator::generateFor(DeclWithRange &DeclAndRange) {

  if (auto *Declaration = dyn_cast_or_null<ParamDecl>(DeclAndRange.Declaration)) {

    if (const auto *FunctionDeclaration =
        dyn_cast<AbstractFunctionDecl>(Declaration->getDeclContext())) {

      auto BaseWithModules =
        ParamExtractor.getBaseOverridenDeclarationWithModules(FunctionDeclaration);
      auto BaseFunctionDeclaration = BaseWithModules.first;
      auto Modules = BaseWithModules.second;

      auto ModuleName = ParamExtractor.moduleName(Declaration);
      auto ExternalName = ParamExtractor.externalParameterName(Declaration);
      auto InternalName = ParamExtractor.internalParameterName(Declaration);

      std::string BaseFunctionName =
        ParamExtractor.declarationName(BaseFunctionDeclaration);
      auto BaseModuleAndParts =
        FuncExtractor.functionIdentifierParts(BaseFunctionDeclaration);
      std::string BaseFunctionModuleName = BaseModuleAndParts.first;
      std::vector<std::string> BaseParts = BaseModuleAndParts.second;

      auto BasePositionOrError =
        getIdentifierWithParameterPosition(Declaration, BaseFunctionDeclaration);
      if (auto Error = BasePositionOrError.takeError()) {
        return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
      } else {
        BaseParts.push_back("parameter.position." + BasePositionOrError.get());
      }

      // We check if parameter has a place that it's declared that we can reach
      if (Declaration->getNameLoc().isValid()) {

        auto IsSingle = Declaration->getArgumentNameLoc().isInvalid();

        auto isFromTheSameModule =
          ParamExtractor.isOverriddenMethodFromTheSameModule(Modules,
                                                             ModuleName);

        DeclsWithSymbolsWithRangesOrErrors Symbols;

        CharSourceRange ComputedRange(Declaration->getNameLoc(),
                                      InternalName.length());

        if (IsSingle) {

          if (isFromTheSameModule) {
            BaseParts.push_back("single." + InternalName);
            CharSourceRange Range(Declaration->getNameLoc(),
                                  InternalName.length());

            Symbol Symbol(combineIdentifier(BaseParts),
                          InternalName,
                          BaseFunctionModuleName,
                          SymbolType::SingleParameter);

            if (ComputedRange.overlaps(DeclAndRange.Range)) {
              Symbols.push_back(DeclWithSymbolWithRange(Declaration, Symbol, Range));
            } else {
              Symbols.push_back(DeclWithSymbolWithRange(DeclAndRange, Symbol));
            }
          }

        } else {

          auto IsExternal = !ExternalName.empty();

          if (IsExternal
              && isFromTheSameModule
              && Declaration->getArgumentNameLoc().isValid()) {

            auto ExternalParts = BaseParts;

            BaseParts.push_back("external." + ExternalName);
            CharSourceRange ExternalRange(Declaration->getArgumentNameLoc(),
                                          ExternalName.length());
            Symbol ExternalSymbol(combineIdentifier(BaseParts),
                                  ExternalName,
                                  BaseFunctionModuleName,
                                  SymbolType::ExternalParameter);

            if (ComputedRange.overlaps(DeclAndRange.Range)) {
              Symbols.push_back(DeclWithSymbolWithRange(Declaration,
                                                        ExternalSymbol,
                                                        ExternalRange));
            } else if (DeclAndRange.Context ==
                         DeclarationProcessingContext::FunctionCallAttribute) {
              Symbols.push_back(DeclWithSymbolWithRange(Declaration,
                                                        ExternalSymbol,
                                                        DeclAndRange.Range));
            }
          }

          if (DeclAndRange.Context !=
                DeclarationProcessingContext::FunctionCallAttribute) {

            //  TODO: improve handling internal parameters in following case:
            //  internal parameter in protocol method implementation,
            //  where declaration and implementation are in different modules -
            //  Symbol object will have different module name in Identifier
            //  and in Module field.

            std::string OriginalFunctionName =
              ParamExtractor.declarationName(FunctionDeclaration);
            std::string OriginalFunctionModuleName =
              ParamExtractor.moduleName(FunctionDeclaration);
            std::vector<std::string> OriginalParts =
              FuncExtractor.functionIdentifierParts(FunctionDeclaration).second;

            auto OriginalPositionOrError =
              getIdentifierWithParameterPosition(Declaration, FunctionDeclaration);
            if (auto Error = OriginalPositionOrError.takeError()) {
              Symbols.push_back(std::move(Error));
              return Symbols;
            } else {
              auto OriginalPosition = OriginalPositionOrError.get();
              OriginalParts.push_back("parameter.position." + OriginalPosition);
            }

            OriginalParts.push_back("internal." + InternalName);
            CharSourceRange InternalRange(Declaration->getNameLoc(),
                                          InternalName.length());
            Symbol InternalSymbol(combineIdentifier(OriginalParts),
                                  InternalName,
                                  OriginalFunctionModuleName,
                                  SymbolType::InternalParameter);

            if (ComputedRange.overlaps(DeclAndRange.Range)) {
              Symbols.push_back(DeclWithSymbolWithRange(Declaration,
                                                        InternalSymbol,
                                                        InternalRange));
            } else {
              Symbols.push_back(DeclWithSymbolWithRange(DeclAndRange,
                                                        InternalSymbol));
            }
          }
        }
        return Symbols;
      }
    }

    return wrapInVector<DeclWithSymbolWithRange>(stringError("Couldn't identify what function parameter belong to"));
  }

  auto Error = stringError("FunctionParameterSymbolGenerator cannot generate symbol "
                           "for non-ParamDecl Declaration");
  return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
}

VariableSymbolGenerator::VariableSymbolGenerator(VariableExtractor &Extractor)
: Extractor(Extractor) {}

DeclsWithSymbolsWithRangesOrErrors
VariableSymbolGenerator::generateFor(DeclWithRange &DeclAndRange) {

  if (auto *Declaration = dyn_cast<VarDecl>(DeclAndRange.Declaration)) {

    auto ModuleAndPartsOrError =
      Extractor.variableIdentifierPartsFromContext(Declaration);
    if (auto Error = ModuleAndPartsOrError.takeError()) {
      return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));
    }
    auto ModuleAndParts = ModuleAndPartsOrError.get();

    if (Declaration->isStatic()) {
      ModuleAndParts.second.push_back("static");
    }

    std::string SymbolName = Extractor.declarationName(Declaration);
    ModuleAndParts.second.push_back("variable." + SymbolName);

    Symbol Symbol(combineIdentifier(ModuleAndParts.second),
                  SymbolName,
                  ModuleAndParts.first,
                  SymbolType::Variable);
    return wrapInVector(DeclWithSymbolWithRange(DeclAndRange, Symbol));
  }

  auto Error = stringError("VariableSymbolGenerator cannot generate symbol "
                           "for non-VarDecl Declaration");
  return wrapInVector<DeclWithSymbolWithRange>(std::move(Error));

}

} //namespace obfuscation
} //namespace swift
