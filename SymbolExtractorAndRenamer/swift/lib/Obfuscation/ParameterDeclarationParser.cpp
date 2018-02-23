#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/VariableDeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
  
llvm::Expected<std::string> position(const ParamDecl *Declaration,
                                     const AbstractFunctionDecl *FunctionDeclaration) {
  
  auto ParameterLists = FunctionDeclaration->getParameterLists();
  for (unsigned ListIndex = 0; ListIndex < ParameterLists.size(); ++ListIndex) {
    
    auto *ParameterList = ParameterLists[ListIndex];
    for (unsigned ParameterIndex = 0;
         ParameterIndex < ParameterList->size();
         ++ParameterIndex) {
      
      auto *ParamDeclaration = ParameterList->get(ParameterIndex);
      if (ParamDeclaration == Declaration) {
        return "list" + std::to_string(ListIndex) +
               "_parameter" + std::to_string(ParameterIndex);
      }
      
    }
    
  }
  
  return stringError("Couldn't find parameter position");
}
  
SymbolsOrError parse(const ParamDecl* Declaration) {
  if (Declaration->isImplicit()) {
    return stringError("We shouldn't rename implicit parameters");
  }
  if (const auto *FunctionDeclaration =
      dyn_cast<AbstractFunctionDecl>(Declaration->getDeclContext())) {
    

    auto BaseWithModules =
      getBaseOverridenDeclarationWithModules(FunctionDeclaration);
    auto BaseFunctionDeclaration = BaseWithModules.first;
    auto Modules = BaseWithModules.second;
    
    bool OverridenMethodIsFromTheSameModule =
      Modules.size() == 0
      || (Modules.size() == 1 && Modules.count(moduleName(Declaration)) == 1);
    
    auto ExternalName = externalParameterName(Declaration);
    auto InternalName = internalParameterName(Declaration);
    
    std::vector<SymbolWithRange> Symbols;
    
    std::string FunctionName = declarationName(BaseFunctionDeclaration);
    auto ModuleAndParts = functionIdentifierParts(BaseFunctionDeclaration);
    std::string FunctionModuleName = ModuleAndParts.first;
    std::vector<std::string> Parts = ModuleAndParts.second;
    
    auto PositionOrError = position(Declaration, BaseFunctionDeclaration);
    if (auto Error = PositionOrError.takeError()) {
      return std::move(Error);
    } else {
      Parts.push_back("parameter.position." + PositionOrError.get());
    }
    
    if (Declaration->getNameLoc().isValid()) {
      if (Declaration->getArgumentNameLoc().isInvalid()
          && OverridenMethodIsFromTheSameModule) {
        
        Parts.push_back("single." + InternalName);
        CharSourceRange Range(Declaration->getNameLoc(),
                              InternalName.length());
        Symbol Symbol(combineIdentifier(Parts),
                      InternalName,
                      FunctionModuleName,
                      SymbolType::SingleParameter);
        Symbols.push_back(SymbolWithRange(Symbol, Range));
        
      } else {
        
        if (!ExternalName.empty() && OverridenMethodIsFromTheSameModule) {
          auto ExternalParts = Parts;
          
          ExternalParts.push_back("external." + ExternalName);
          CharSourceRange ExternalRange(Declaration->getArgumentNameLoc(),
                                        ExternalName.length());
          Symbol ExternalSymbol(combineIdentifier(ExternalParts),
                                ExternalName,
                                FunctionModuleName,
                                SymbolType::ExternalParameter);
          Symbols.push_back(SymbolWithRange(ExternalSymbol, ExternalRange));
          
        }
        
        //  TODO: improve handling internal parameters cases:
        //  Case1: if we have two implementations of the same protocol
        //  method in the same module and those implementations have the same
        //  internal parameter name - this internal parameter will be renamed
        //  to the same obfuscated name in both implementations.
        //  Case2: internal parameter in protocol method implementation,
        //  where declaration and implementation are in different modules -
        //  Symbol object will have different module name in Identifier
        //  and in Module field.
        Parts.push_back("internal." + InternalName);
        CharSourceRange InternalRange(Declaration->getNameLoc(),
                                      InternalName.length());
        Symbol InternalSymbol(combineIdentifier(Parts),
                              InternalName,
                              moduleName(Declaration),
                              SymbolType::InternalParameter);
        Symbols.push_back(SymbolWithRange(InternalSymbol, InternalRange));
      }
    }
    
    return Symbols;
  }
  
  return stringError("Couldn't identify what function parameter belong to");
}
  
SymbolsOrError parametersSymbolsFromFunction(const AbstractFunctionDecl* Declaration) {
    
  std::vector<SymbolWithRange> Symbols;

  auto ParameterLists = Declaration->getParameterLists();
  for (auto *ParameterList : ParameterLists) {
    for (auto *Parameter : *ParameterList) {
      if (!Parameter->isImplicit()) {
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

SingleSymbolOrError
symbolFromMemberwiseConstructorParameter(const ParamDecl* Parameter) {
  auto *Context = Parameter->getDeclContext();
  if (const auto *Constructor = dyn_cast<ConstructorDecl>(Context)) {
    auto *StructDeclaration =
    Constructor->getResultInterfaceType()->getStructOrBoundGenericStruct();
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
parseSeparateFunctionDeclarationForParameters(const AbstractFunctionDecl* Declaration) {
  return parametersSymbolsFromFunction(Declaration);
}
  
SymbolsOrError
parseFunctionFromCallExpressionForParameters(const FuncDecl* Declaration) {
  
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

llvm::Expected<SymbolWithRange> buildSymbol(Identifier Name, ValueDecl *Decl,
                                            CharSourceRange Range) {
  if (const auto *FunctionDecl = dyn_cast<AbstractFunctionDecl>(Decl)) {
    auto ParameterLists = FunctionDecl->getParameterLists();
    auto ParameterName = Name.str();
    
    for (auto *ParameterList: ParameterLists) {
      for (auto *Parameter : *ParameterList) {
        if (ParameterName == internalParameterName(Parameter)
            || ParameterName == externalParameterName(Parameter)) {
          
          if (isMemberwiseConstructorParameter(Parameter)) {
            auto SymbolOrError =
            symbolFromMemberwiseConstructorParameter(Parameter);
            if (auto Error = SymbolOrError.takeError()) {
              return std::move(Error);
            } else {
              auto Symbol = SymbolOrError.get();
              return SymbolWithRange(Symbol, Range);
            }
          } else {
            SymbolsOrError Symbols = parse(Parameter);
            if (auto Error = Symbols.takeError()) {
              return std::move(Error);
            } else {
              if (Symbols.get().size() > 0) {
                auto Symbol = Symbols.get()[0];
                Symbol.Range = Range;
                return Symbol;
              }
            }
          }
        }
      }
    }
    return stringError("Cannot find parameter identifier in function declaration");
  } else {
    return stringError("Cannot build symbol for argument without "
                       "function declaration");
  }
}


} //namespace obfuscation
} //namespace swift
