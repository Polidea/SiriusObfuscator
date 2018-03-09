#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

llvm::Expected<std::string>
getIdentifierWithParameterPosition(const ParamDecl *Declaration,
                                   const AbstractFunctionDecl *
                                    FunctionDeclaration) {
  
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

SymbolsOrError parse(const ParamDecl* Declaration) {

  if (const auto *FunctionDeclaration =
        dyn_cast<AbstractFunctionDecl>(Declaration->getDeclContext())) {

    auto BaseWithModules =
      getBaseOverridenDeclarationWithModules(FunctionDeclaration);
    auto BaseFunctionDeclaration = BaseWithModules.first;
    auto Modules = BaseWithModules.second;

    auto ModuleName = moduleName(Declaration);
    auto ExternalName = externalParameterName(Declaration);
    auto InternalName = internalParameterName(Declaration);
    
    std::vector<SymbolWithRange> Symbols;

    std::string BaseFunctionName = declarationName(BaseFunctionDeclaration);
    auto BaseModuleAndParts = functionIdentifierParts(BaseFunctionDeclaration);
    std::string BaseFunctionModuleName = BaseModuleAndParts.first;
    std::vector<std::string> BaseParts = BaseModuleAndParts.second;

    auto BasePositionOrError =
      getIdentifierWithParameterPosition(Declaration, BaseFunctionDeclaration);
    if (auto Error = BasePositionOrError.takeError()) {
      return std::move(Error);
    } else {
      BaseParts.push_back("parameter.position." + BasePositionOrError.get());
    }

    // We check if parameter has a place that it's declared that we can reach
    if (Declaration->getNameLoc().isValid()) {

      auto IsSingle = Declaration->getArgumentNameLoc().isInvalid();

      auto isFromTheSameModule = isOverriddenMethodFromTheSameModule(Modules,
                                                                     ModuleName);

      if (IsSingle) {

        if (isFromTheSameModule) {
          BaseParts.push_back("single." + InternalName);
          CharSourceRange Range(Declaration->getNameLoc(),
                                InternalName.length());
          Symbol Symbol(combineIdentifier(BaseParts),
                        InternalName,
                        BaseFunctionModuleName,
                        SymbolType::SingleParameter);
          Symbols.push_back(SymbolWithRange(Symbol, Range));
        }
        
      } else {

        auto IsExternal = !ExternalName.empty();

        if (IsExternal && isFromTheSameModule) {
          auto ExternalParts = BaseParts;
          
          BaseParts.push_back("external." + ExternalName);
          CharSourceRange ExternalRange(Declaration->getArgumentNameLoc(),
                                        ExternalName.length());
          Symbol ExternalSymbol(combineIdentifier(BaseParts),
                                ExternalName,
                                BaseFunctionModuleName,
                                SymbolType::ExternalParameter);
          Symbols.push_back(SymbolWithRange(ExternalSymbol, ExternalRange));
          
        }
        
        //  TODO: improve handling internal parameters in following case:
        //  internal parameter in protocol method implementation,
        //  where declaration and implementation are in different modules -
        //  Symbol object will have different module name in Identifier
        //  and in Module field.

        std::string OriginalFunctionName = declarationName(FunctionDeclaration);
        std::string OriginalFunctionModuleName =
          moduleName(FunctionDeclaration);
        std::vector<std::string> OriginalParts =
          functionIdentifierParts(FunctionDeclaration).second;

        auto OriginalPositionOrError =
          getIdentifierWithParameterPosition(Declaration, FunctionDeclaration);
        if (auto Error = OriginalPositionOrError.takeError()) {
          return std::move(Error);
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
        Symbols.push_back(SymbolWithRange(InternalSymbol, InternalRange));
      }
    }
    
    return Symbols;
  }
  
  return stringError("Couldn't identify what function parameter belong to");
}


SingleSymbolOrError
symbolFromMemberwiseConstructorParameter(const ParamDecl* Parameter) {
  auto *Context = Parameter->getDeclContext();
  if (const auto *Constructor = dyn_cast<ConstructorDecl>(Context)) {
    auto *StructDeclaration =
    Constructor->getResultInterfaceType()->getStructOrBoundGenericStruct();
    if (StructDeclaration == nullptr) {
      return stringError("The supposedly memberwise constructor is not "
                         "memberwise, because it doesn't come from struct");
    }
    auto Properties = StructDeclaration->getStoredProperties();
    for (auto Variable : Properties) {
      if (declarationName(Variable) == declarationName(Parameter)) {
        return parse(Variable);
      }
    }
    return stringError("Failed to find struct property with the same name as "
                       "memberwise constructor parameter");
  } else {
    return stringError("Failed to parse constructor declaration"
                       "from parameter");
  }
}
  
SymbolsOrError
parametersSymbolsFromFunction(const AbstractFunctionDecl* Declaration) {
    
  std::vector<SymbolWithRange> Symbols;

  auto ParameterLists = Declaration->getParameterLists();
  for (auto *ParameterList : ParameterLists) {
    for (auto *Parameter : *ParameterList) {
      if (isMemberwiseConstructorParameter(Parameter)) {
        auto SingleSymbolOrError =
          symbolFromMemberwiseConstructorParameter(Parameter);
        if (auto Error = SingleSymbolOrError.takeError()) {
          llvm::consumeError(std::move(Error));
        } else {
          CharSourceRange Range(Parameter->getNameLoc(),
                                SingleSymbolOrError.get().Name.length());
          SymbolWithRange SymbolWithRange(SingleSymbolOrError.get(), Range);
          Symbols.push_back(SymbolWithRange);
        }
      } else if (!Parameter->isImplicit()) {
        auto SymbolsOrError = parse(Parameter);
        if (auto Error = SymbolsOrError.takeError()) {
          return std::move(Error);
        } else {
          copyToVector(SymbolsOrError.get(), Symbols);
        }
      }
    }
  }

  return Symbols;
}

SymbolsOrError
parseSeparateFunctionDeclarationForParameters(const AbstractFunctionDecl*
                                                Declaration) {
  return parametersSymbolsFromFunction(Declaration);
}
  
SymbolsOrError
parseFunctionFromCallExpressionForParameters(const AbstractFunctionDecl*
                                              Declaration) {
  
  auto SymbolsOrError = parametersSymbolsFromFunction(Declaration);
  
  if (auto Error = SymbolsOrError.takeError()) {
    return std::move(Error);
  } else {
    
    auto Symbols = SymbolsOrError.get();
    auto SymbolsEnd = std::remove_if(Symbols.begin(),
                                     Symbols.end(),
                                     [](const SymbolWithRange &Element) {
       return Element.Symbol.Type == SymbolType::InternalParameter;
    });
    Symbols.erase(SymbolsEnd, Symbols.end());
    return Symbols;
    
  }
}

SymbolsOrError parseSeparateDeclarationWithRange(const ParamDecl* Declaration,
                                                 CharSourceRange Range) {

  if (Declaration->isImplicit()) {
    return stringError("We must not rename the implicit parameters "
                       "at the usage place.");
  }
  
  auto SymbolsOrError = parse(Declaration);
  if (auto Error = SymbolsOrError.takeError()) {
    return std::move(Error);
  }
  
  auto Symbols = SymbolsOrError.get();
  
  std::vector<SymbolWithRange> Result;
  for (auto &Symbol : Symbols) {
    if (Range.overlaps(Symbol.Range)) {
      return stringError("Not separate declaration being passed to "
                         "`parseSeparateDeclarationWithRange()` method");
    }
    if (Symbol.Symbol.Type != SymbolType::ExternalParameter) {
      Result.push_back(SymbolWithRange(Symbol.Symbol, Range));
    }
  }
  return Result;
}

} //namespace obfuscation
} //namespace swift
