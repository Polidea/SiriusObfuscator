#include "swift/Obfuscation/DataStructures.h"

using namespace swift::obfuscation;

namespace swift {
namespace obfuscation {

bool Symbol::operator< (const Symbol &Right) const {
  return Identifier < Right.Identifier;
}

} //namespace obfuscation
} //namespace swift

namespace llvm {
namespace yaml {

void MappingTraits<FilesJson>::mapping(IO &Io, FilesJson &Object) {
  Io.mapRequired("project", Object.Project);
  Io.mapRequired("module", Object.Module);
  Io.mapRequired("sdk", Object.Sdk);
  Io.mapRequired("filenames", Object.Filenames);
  Io.mapRequired("systemLinkedFrameworks", Object.SystemLinkedFrameworks);
  Io.mapRequired("explicitelyLinkedFrameworks",
                 Object.ExplicitelyLinkedFrameworks);
}
  
void MappingTraits<Project>::mapping(IO &Io, Project &Object) {
  Io.mapRequired("rootPath", Object.RootPath);
}

typedef swift::obfuscation::Module ObfuscationModule;
void MappingTraits<ObfuscationModule>::mapping(IO &Io,
                                               ObfuscationModule &Object) {
  Io.mapRequired("name", Object.Name);
}

void MappingTraits<Sdk>::mapping(IO &Io, Sdk &Object) {
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("path", Object.Path);
}

typedef ExplicitelyLinkedFrameworks ELF;
void MappingTraits<ELF>::mapping(IO &Io, ELF &Object) {
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("path", Object.Path);
}

void MappingTraits<SymbolsJson>::mapping(IO &Io, SymbolsJson &Object) {
  Io.mapRequired("symbols", Object.Symbols);
}

void MappingTraits<Symbol>::mapping(IO &Io, Symbol &Object) {
  Io.mapRequired("identifier", Object.Identifier);
  Io.mapRequired("name", Object.Name);
}

void MappingTraits<RenamesJson>::mapping(IO &Io, RenamesJson &Object) {
  Io.mapRequired("symbols", Object.Symbols);
}

void MappingTraits<SymbolRenaming>::mapping(IO &Io, SymbolRenaming &Object) {
  Io.mapRequired("identifier", Object.Identifier);
  Io.mapRequired("originalName", Object.OriginalName);
  Io.mapRequired("obfuscatedName", Object.ObfuscatedName);
}

template <typename U>
size_t SequenceTraits<std::vector<U>>::size(IO &Io, std::vector<U> &Vec) {
  return Vec.size();
}

template <typename U>
U& SequenceTraits<std::vector<U>>::element(IO &Io,
                                           std::vector<U> &Vec,
                                           size_t Index) {
  if (Vec.size() <= Index) {
    Vec.resize(Index + 1);
  }
  return Vec[Index];
}

} // namespace yaml
} // namespace llvm

namespace swift {
namespace json {

void ObjectTraits<SymbolsJson>::mapping(Output &Out, SymbolsJson &Object) {
  Out.mapRequired("symbols", Object.Symbols);
}

void ObjectTraits<Symbol>::mapping(Output &Out, Symbol &Object) {
  Out.mapRequired("name", Object.Name);
  Out.mapRequired("identifier", Object.Identifier);
}

void ObjectTraits<RenamesJson>::mapping(Output &Out, RenamesJson &Object) {
  Out.mapRequired("symbols", Object.Symbols);
}

void ObjectTraits<SymbolRenaming>::mapping(Output &Out, SymbolRenaming &Object) {
  Out.mapRequired("identifier", Object.Identifier);
  Out.mapRequired("originalName", Object.OriginalName);
  Out.mapRequired("obfuscatedName", Object.ObfuscatedName);
}

} // namespace json
} // namespace swift

