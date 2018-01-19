#include "swift/Obfuscation/SourceFileWalker.h"
#include "swift/Obfuscation/DeclarationParser.h"

#include <string>

namespace swift {
namespace obfuscation {
  
const char* pointerToRangeValue(const SymbolWithRange &Symbol) {
  auto Pointer = Symbol.Range.getStart().getOpaquePointerValue();
  return static_cast<const char *>(Pointer);
}
  
bool SymbolWithRange::operator< (const SymbolWithRange &Right) const {
  auto less = std::less<const char *>();
  if (const auto* RangeValuePointer = pointerToRangeValue(*this)) {
    if (const auto* RightRangeValuePointer = pointerToRangeValue(Right)) {
      auto isRangeLess = less(RangeValuePointer, RightRangeValuePointer);
      return Symbol < Right.Symbol || isRangeLess;
    }
  }
  assert(false && "Comparing Symbols with Ranges requires Ranges Start "
                  "Location Values Pointers to be of const char type");
}

struct RenamesCollector: public SourceEntityWalker {
  std::set<SymbolWithRange> Bucket;
  
  void handleSymbol(Symbol &Symbol, const CharSourceRange &Range) {
    Bucket.insert(SymbolWithRange(Symbol, Range));
  }
  
  bool walkToDeclPre(Decl *Declaration, CharSourceRange Range) override {
    if (Declaration->isImplicit()) {
      return false;
    }
    auto SymbolOrError = extractSymbol(Declaration);
    if (auto Error = SymbolOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbol(SymbolOrError.get(), Range);
    return true;
  }
  
  bool visitDeclReference(ValueDecl *Declaration, CharSourceRange Range,
                          TypeDecl *CtorTyRef, ExtensionDecl *ExtTyRef,
                          Type T, ReferenceMetaData Data) override {
    
    std::unique_ptr<llvm::Expected<Symbol>> SymbolOrError(nullptr);
    if (CtorTyRef) {
      SymbolOrError =
        llvm::make_unique<llvm::Expected<Symbol>>(extractSymbol(CtorTyRef));
    } else {
       SymbolOrError =
        llvm::make_unique<llvm::Expected<Symbol>>(extractSymbol(Declaration));
    }
    if (auto Error = SymbolOrError->takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbol(SymbolOrError->get(), Range);
    return true;
  }
};

std::set<SymbolWithRange> walkAndCollectSymbols(SourceFile &SourceFile) {
  RenamesCollector Collector;
  Collector.walk(SourceFile);
  return Collector.Bucket;
}

} //namespace obfuscation
} //namespace swift
