#include "swift/Obfuscation/FunctionDeclarationParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include <string>
#include <vector>

namespace swift {
namespace obfuscation {

llvm::Error isDeclarationSupported(const FuncDecl* Declaration) {
  if (Declaration->isGetterOrSetter()) {
    return stringError("don't support getters and setters right now, since "
                       "it's the computed property name that should be "
                       "obfuscated");
  }
  if (Declaration->isAccessor() || Declaration->isObservingAccessor()) {
    return stringError("don't support property accessors right now");
  }
  return llvm::Error::success();
}

std::string functionSignature(const AbstractFunctionDecl *Declaration) {
  // The signature is available via different getters depending on whether
  // it is a method or a free function
  std::string Interface;
  if (Declaration->getDeclContext()->isTypeContext()) {
    Interface = Declaration->getMethodInterfaceType().getString();
  } else {
    Interface = Declaration->getInterfaceType().getString();
  }
  return "signature." + Interface;
}

ModuleNameAndParts
functionIdentifierParts(const AbstractFunctionDecl *Declaration) {

  std::string ModuleName;
  std::vector<std::string> Parts;

  std::string SymbolName = declarationName(Declaration);

  // Check if function is part of protocol declaration
  auto *ProtocolDeclaration =
    Declaration->getDeclContext()->getAsProtocolOrProtocolExtensionContext();
  auto IsPartOfProtocol = ProtocolDeclaration != nullptr;

  // Check if function satisfies the protocol implemented by its
  // containing class
  auto ProtocolRequirements = Declaration->getSatisfiedProtocolRequirements();
  auto SatisfiesProtocol = !ProtocolRequirements.empty();

  if (!(SatisfiesProtocol || IsPartOfProtocol)) {
    // This logic applies to function that has nothing to do with protocols

    auto ModuleNameAndParts = moduleNameAndIdentifierParts(Declaration);
    ModuleName = ModuleNameAndParts.first;
    Parts = ModuleNameAndParts.second;

    // Build different identifier depending whether
    // the function is a free function or method
    auto TypeNameOrError = enclosingTypeName(Declaration);
    if (auto Error = TypeNameOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      Parts.push_back("function." + SymbolName);
    } else {
      Parts.push_back("type." + TypeNameOrError.get());
      if (Declaration->isStatic()) {
        Parts.push_back("static");
      }
      Parts.push_back("method." + SymbolName);
    }
    
  } else {
    // This logic applies to function that
    // is part of protocol or satisfies protocol
    
    // TODO: right now we're renaming all the methods in the protocols with
    //       the same name and signature to the same obfuscated name. the reason
    //       is that it greatly simplifies the handling of situation in which
    //       a protocol A has method a() and protocol B: A has method a().
    //       then the class C: B with the implementation of a() satisfies
    //       two requirements at the same time (from A and from B). however,
    //       there is no override relationship between the A.a() and B.a() in
    //       protocols. it's just a name that's the same.
    //       this simplified handling should be improved in the future.
    ModuleNameAndParts ModuleNameAndParts;
    if (SatisfiesProtocol) {
      ModuleNameAndParts =
        moduleNameAndIdentifierParts(ProtocolRequirements.front());
    } else {
      ModuleNameAndParts = moduleNameAndIdentifierParts(ProtocolDeclaration);
    }
    ModuleName = ModuleNameAndParts.first;
    Parts = ModuleNameAndParts.second;
    
    Parts.push_back("protocol");
    if (Declaration->isStatic()) {
      Parts.push_back("static");
    }
    Parts.push_back("method." + SymbolName);
  }
  
  Parts.push_back(functionSignature(Declaration));
  
  return std::make_pair(ModuleName, Parts);
}

SymbolWithRange getFunctionSymbol(GlobalCollectedSymbols &CollectedSymbols,
                                  const swift::FuncDecl *Declaration,
                                  const swift::CharSourceRange &Range) {
  auto ModuleAndParts = functionIdentifierParts(Declaration);
  auto ModuleName = ModuleAndParts.first;
  auto Parts = ModuleAndParts.second;
  Symbol Symbol(combineIdentifier(Parts),
                declarationName(Declaration),
                ModuleName,
                SymbolType::NamedFunction);
  return SymbolWithRange(Symbol, Range);
}

llvm::Expected<SymbolWithRange>
parseOverridenDeclaration(GlobalCollectedSymbols &CollectedSymbols,
                          const FuncDecl *Declaration,
                          const std::string &ModuleName,
                          const CharSourceRange &Range) {

  auto BaseWithModules = getBaseOverridenDeclarationWithModules(Declaration);
  auto Base = BaseWithModules.first;
  auto Modules = BaseWithModules.second;

  // Emits symbol only if the base overriden function and
  // all the functions overriding it in the inheritance hierarchy are from
  // the same module and it's the module we've passed as ModuleName parameter.
  // Emitted symbol represents the base function so that all the functions that
  // override it are renamed to the same obfuscated name
  if (isOverriddenMethodFromTheSameModule(Modules, ModuleName)) {
    return getFunctionSymbol(CollectedSymbols, Base, Range);
  } else {
    return stringError("only method overriding methods from the same module "
                       "might be safely obfuscated");
  }
}
  
llvm::Expected<bool>
handleSatisfiedProtocolRequirements(GlobalCollectedSymbols &CollectedSymbols,
                                    SymbolWithRange FunctionNameSymbol,
                                    const FuncDecl* Declaration) {
  
  //check if this overridden method is also satisfying some protocol
  auto SatisfiesProtocol
                  = Declaration->getSatisfiedProtocolRequirements().size() > 0;
  
  // we assume that there is always only one overriden symbol
  if(SatisfiesProtocol) {
    
    for(auto Requirement: Declaration->getSatisfiedProtocolRequirements() ) {
      
      if(auto *ProtocolFun = dyn_cast<FuncDecl>(Requirement)) {
        auto ModuleAndParts = functionIdentifierParts(ProtocolFun);
        auto Parts = ModuleAndParts.second;
        auto ProtocolFunId = combineIdentifier(Parts);
        
        // Create the symbols for protocol function parameters
        auto ProtocolParametersSymbolsOrError
                  = parseSeparateFunctionDeclarationForParameters(ProtocolFun);
        if (auto Error = ProtocolParametersSymbolsOrError.takeError()) {
          return std::move(Error);
        }
        auto ProtocolFunParametersSymbols
                                      = ProtocolParametersSymbolsOrError.get();
        
        // Create the symbols for overridden function parameters
        auto OverriddenParametersSymbolsOrError =
                           parseSeparateFunctionDeclarationForParameters(Declaration);
        if (auto Error = OverriddenParametersSymbolsOrError.takeError()) {
          return std::move(Error);
        }
        auto OverriddenFunParametersSymbols
                                    = OverriddenParametersSymbolsOrError.get();
        
        // Parameter count for both protocol method and overridden method
        // must be the same, otherwise we don't know what to do with them.
        if(OverriddenFunParametersSymbols.size()
                                      != ProtocolFunParametersSymbols.size()) {
          return stringError("Couldn't parse overriden function protocol "
                             "parameters.");
        }
        
        // rename protocol method symbol id
        
        // find protocol function identifier in a set of all collected symbols
        // and replace it with function identifier of overridden symbol
        for(auto CollectedSymbol: CollectedSymbols) {
          if(CollectedSymbol.SymbolWithRange.Symbol.Identifier
                                                          == ProtocolFunId) {
            
            CollectedSymbols.erase(CollectedSymbol);
            CollectedSymbol.SymbolWithRange.Symbol.Identifier
                                        = FunctionNameSymbol.Symbol.Identifier;
            CollectedSymbols.insert(CollectedSymbol);
            
            break;
          }
        }
        
        // rename protocol method parameters symbol ids
        for(size_t i = 0; i<ProtocolFunParametersSymbols.size(); i++) {
          auto ProtocolFunParameter = ProtocolFunParametersSymbols[i];
          auto OverridenFunParameter = OverriddenFunParametersSymbols[i];
          
          // find protocol parameter identifier in a set of all collected symbols
          // and replace it with parameter identifier of overridden symbol
          for(auto CollectedSymbol: CollectedSymbols) {
            if(CollectedSymbol.SymbolWithRange.Symbol.Identifier
                                  == ProtocolFunParameter.Symbol.Identifier) {

              CollectedSymbols.erase(CollectedSymbol);
              CollectedSymbol.SymbolWithRange.Symbol.Identifier
                                    = OverridenFunParameter.Symbol.Identifier;
              CollectedSymbols.insert(CollectedSymbol);
              
              break;
            }
          }
        }
        
      }
    }
  }
  return true;
}

SymbolsOrError parse(const ConstructorDecl* Declaration,
                     CharSourceRange Range) {
  // We're not interested in renaming the init function name,
  // but we're interested in renaming the init parameters
  if (Declaration->isImplicit()) {
    return stringError("We dont want to parse the implicit constructor "
                       "declarations, only their usage via calls.");
  }
  return parseSeparateFunctionDeclarationForParameters(Declaration);
}

SymbolsOrError parse(GlobalCollectedSymbols &CollectedSymbols,
                     const FuncDecl* Declaration,
                     CharSourceRange Range) {
  
  if (auto Error = isDeclarationSupported(Declaration)) {
    return std::move(Error);
  }

  std::vector<SymbolWithRange> Symbols;

  // Create the symbol for function
  if (Declaration->getOverriddenDecl() != nullptr) {
    // Overriden declaration must be treated separately because
    // we mustn't rename function that overrides function from different module
    auto SymbolOrError =
      parseOverridenDeclaration(CollectedSymbols,
                                Declaration,
                                moduleName(Declaration),
                                Range);
    if (auto Error = SymbolOrError.takeError()) {
      return std::move(Error);
    }
    
    auto FunctionNameSymbol = SymbolOrError.get();
    
    // If overridden method also satisfies protocol requirements
    // we must update symbol identifier for protocol's method to be the same
    // as symbol identifier of the overridden function. Otherwise function
    // inside protocol would be renamed differently and our class
    // will no longer conform to that protocol.
    auto HandledOrError = handleSatisfiedProtocolRequirements(
                                                            CollectedSymbols,
                                                            FunctionNameSymbol,
                                                            Declaration);
    
    if (auto Error = HandledOrError.takeError()) {
      return std::move(Error);
    }
    
    Symbols.push_back(FunctionNameSymbol);
  } else {
    Symbols.push_back(getFunctionSymbol(CollectedSymbols,
                                        Declaration,
                                        Range));
  }

  // Create the symbols for function parameters
  auto ParametersSymbolsOrError =
    parseSeparateFunctionDeclarationForParameters(Declaration);
  if (auto Error = ParametersSymbolsOrError.takeError()) {
    return std::move(Error);
  }

  copyToVector(ParametersSymbolsOrError.get(), Symbols);

  // Return both the function symbol and the parameters symbols together
  return Symbols;
}

} //namespace obfuscation
} //namespace swift
