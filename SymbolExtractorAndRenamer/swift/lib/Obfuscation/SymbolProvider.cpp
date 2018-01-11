#include "swift/Obfuscation/SymbolProvider.h"
#include "swift/Obfuscation/Utils.h"

#include <sstream>
#include <string>
#include <vector>

namespace swift {
namespace obfuscation {
  
llvm::Expected<Symbol> extractSymbol(Decl* Declaration) {
  std::vector<std::string> Parts;
  std::string SymbolName;
  if (const auto *NominalTypeDeclaration = dyn_cast<NominalTypeDecl>(Declaration)) {
    Parts.push_back("module");
    Parts.push_back(NominalTypeDeclaration->getModuleContext()->getBaseName().getIdentifier().get());
    if (auto *EnumDeclaration = dyn_cast<EnumDecl>(NominalTypeDeclaration)) {
      SymbolName = EnumDeclaration->getDeclaredInterfaceType()->getString();
      Parts.push_back("enum." + SymbolName);
    } else if (auto *ClassDeclaration = dyn_cast<ClassDecl>(NominalTypeDeclaration)) {
      SymbolName = ClassDeclaration->getDeclaredInterfaceType()->getString();
      Parts.push_back("class." + SymbolName);
    } else if (auto *ProtocolDeclaration = dyn_cast<ProtocolDecl>(NominalTypeDeclaration)) {
      SymbolName = ProtocolDeclaration->getDeclaredInterfaceType()->getString();
      Parts.push_back("protocol." + SymbolName);
    } else if (auto *StructDeclaration = dyn_cast<StructDecl>(NominalTypeDeclaration)) {
      SymbolName = StructDeclaration->getDeclaredInterfaceType()->getString();
      Parts.push_back("struct." + SymbolName);
    } else {
      return stringError("found unsupported declaration type");
    }
  } else {
    return stringError("found unsupported declaration type");
  }
  
  std::string StringParts;
  if (Parts.size() == 1) {
    StringParts = Parts[0];
  } else {
    //TODO: can we rewrite it to use llvm:raw_string_ostream?
    std::stringstream Result;
    std::copy(Parts.begin(),
              Parts.end(),
              std::ostream_iterator<std::string>(Result, "."));
    StringParts = Result.str();
    StringParts.pop_back();
  }
  
  Symbol SymbolStruct;
  SymbolStruct.Identifier = StringParts;
  SymbolStruct.Name = SymbolName;
  return SymbolStruct;
}

bool SymbolWithRange::operator< (const SymbolWithRange &Right) const {
  return Symbol < Right.Symbol;
}

struct RenamesCollector: public SourceEntityWalker {
  std::set<SymbolWithRange> Bucket;
  RenamesCollector() {}
  
  void handleSymbol(const Symbol &Symbol, const CharSourceRange &Range) {
    Bucket.insert(SymbolWithRange(Symbol, Range));
  }
  
  //TODO: this should only determine if we're interested in declaration
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
    auto SymbolOrError = extractSymbol(Declaration);
    if (auto Error = SymbolOrError.takeError()) {
      llvm::consumeError(std::move(Error));
      return true;
    }
    handleSymbol(SymbolOrError.get(), Range);
    return true;
  }
};

std::set<SymbolWithRange> findSymbolsWithRanges(SourceFile &SourceFile) {
  RenamesCollector Collector;
  Collector.walk(SourceFile);
  return Collector.Bucket;
}

} //namespace obfuscation
} //namespace swift
