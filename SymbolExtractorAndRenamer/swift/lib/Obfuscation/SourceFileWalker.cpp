#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/DeclarationParser.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"
#include "swift/Obfuscation/ExpressionParser.h"
#include "swift/Obfuscation/ParameterDeclarationParser.h"
#include "swift/Obfuscation/Utils-Template.h"
#include "swift/Obfuscation/Utils.h"
#include "swift/Obfuscation/DeclarationParsingUtils.h"

#include <string>

namespace swift {
namespace obfuscation {

struct RenamesCollector: public SourceEntityWalker {
  std::set<SymbolWithRange> Bucket;
  
  void handleSymbols(std::vector<SymbolWithRange> &Symbols) {
    for (auto &Symbol : Symbols) {
      Bucket.insert(Symbol);
    }
  }

  bool walkToExprPre(Expr *Expression) override {
    auto Symbols = extractSymbol(Expression);
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbols(Symbols.get());
    return true;
  }
  
  bool walkToDeclPre(Decl *Declaration, CharSourceRange Range) override {
    if (Declaration->isImplicit()) {
      return false;
    }
    auto Symbols = extractSymbol(Declaration, Range);
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbols(Symbols.get());
    return true;
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
    return stringError("Cannot find parameter identifier in function declaration");
  } else {
    return stringError("Cannot build symbol for argument without "
                         "function declaration");
    }
  }

  bool visitCallArgName(Identifier Name, CharSourceRange Range,
                                  ValueDecl *D) override {

    auto Symbol = buildSymbol(Name, D, Range);
      if (auto Error = Symbol.takeError()) {
        llvm::consumeError(std::move(Error));
      } else {
        Bucket.insert(Symbol.get());
      }
      return true;
  }

  bool visitDeclReference(ValueDecl *Declaration, CharSourceRange Range,
                          TypeDecl *CtorTyRef, ExtensionDecl *ExtTyRef,
                          Type T, ReferenceMetaData Data) override {
    auto Symbols = extractSymbol(CtorTyRef ? CtorTyRef : Declaration, Range);
    handleExtractionResult(Symbols);
    return true;
  }

  void handleExtractionResult(SymbolsOrError &Symbols) {
    if (auto Error = Symbols.takeError()) {
      llvm::consumeError(std::move(Error));
    } else {
      handleSymbols(Symbols.get());
    }
  }
};

std::set<SymbolWithRange> walkAndCollectSymbols(SourceFile &SourceFile) {
  RenamesCollector Collector;
  Collector.walk(SourceFile);
  return Collector.Bucket;
}

} //namespace obfuscation
} //namespace swift
