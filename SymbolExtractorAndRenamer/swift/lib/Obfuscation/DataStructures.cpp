#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Utils.h"

namespace swift {
namespace obfuscation {
  
namespace SymbolTypeKeys {
  static const char* Type = "type";
  static const char* NamedFunction = "namedFunction";
  static const char* ExternalParameter = "externalParameter";
  static const char* InternalParameter = "internalParameter";
  static const char* SingleParameter = "singleParameter";
  static const char* Variable = "variable";
  static const char* Operator = "operator";
}

Symbol::Symbol(const std::string &Identifier,
       const std::string &Name,
       const std::string &Module,
       SymbolType Type)
: Identifier(Identifier), Name(Name), Module(Module), Type(Type) {};

bool Symbol::operator< (const Symbol &Right) const {
  return Identifier < Right.Identifier;
}
  
bool Symbol::operator== (const Symbol &Right) const {
  return Identifier == Right.Identifier
  && Name == Right.Name
  && Module == Right.Module
  && Type == Right.Type;
}
  
SymbolRenaming::SymbolRenaming(const std::string &Identifier,
                               const std::string &OriginalName,
                               const std::string &ObfuscatedName,
                               const std::string &Module,
                               SymbolType Type)
: Identifier(Identifier),
  OriginalName(OriginalName),
  ObfuscatedName(ObfuscatedName),
  Module(Module),
  Type(Type) {};

bool SymbolRenaming::operator== (const SymbolRenaming &Right) const {
  return Identifier == Right.Identifier
  && ObfuscatedName == Right.ObfuscatedName
  && OriginalName == Right.OriginalName
  && Module == Right.Module
  && Type == Right.Type;
}

const char* pointerToRangeValue(const SymbolWithRange &Symbol) {
  auto Pointer = Symbol.Range.getStart().getOpaquePointerValue();
  return static_cast<const char *>(Pointer);
}

SymbolWithRange::SymbolWithRange(const struct Symbol &Symbol,
                                 const CharSourceRange &Range)
: Symbol(Symbol), Range(Range) {}
  
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
  
} //namespace obfuscation
} //namespace swift

namespace llvm {
namespace yaml {

void MappingTraits<FilesJson>::mapping(IO &Io, FilesJson &Object) {
  Io.mapRequired("project", Object.Project);
  Io.mapRequired("module", Object.Module);
  Io.mapRequired("sdk", Object.Sdk);
  Io.mapRequired("sourceFiles", Object.SourceFiles);
  Io.mapRequired("layoutFiles", Object.LayoutFiles);
  Io.mapRequired("systemLinkedFrameworks", Object.SystemLinkedFrameworks);
  Io.mapRequired("explicitlyLinkedFrameworks",
                 Object.ExplicitlyLinkedFrameworks);
}
  
void MappingTraits<Project>::mapping(IO &Io, Project &Object) {
  Io.mapRequired("rootPath", Object.RootPath);
  Io.mapRequired("projectFilePath", Object.ProjectFilePath);
}

using ObfuscationModule = swift::obfuscation::Module;
void MappingTraits<ObfuscationModule>::mapping(IO &Io,
                                               ObfuscationModule &Object) {
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("triple", Object.TargetTriple);
}

void MappingTraits<Sdk>::mapping(IO &Io, Sdk &Object) {
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("path", Object.Path);
}

using ELF = ExplicitlyLinkedFrameworks;
void MappingTraits<ELF>::mapping(IO &Io, ELF &Object) {
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("path", Object.Path);
}

void MappingTraits<SymbolsJson>::mapping(IO &Io, SymbolsJson &Object) {
  Io.mapRequired("symbols", Object.Symbols);
}
  
void ScalarEnumerationTraits<SymbolType>::enumeration(IO &Io,
                                                      SymbolType &Enum) {
  Io.enumCase(Enum, SymbolTypeKeys::Type, SymbolType::Type);
  Io.enumCase(Enum,
              SymbolTypeKeys::ExternalParameter,
              SymbolType::ExternalParameter);
  Io.enumCase(Enum,
              SymbolTypeKeys::InternalParameter,
              SymbolType::InternalParameter);
  Io.enumCase(Enum,
              SymbolTypeKeys::SingleParameter,
              SymbolType::SingleParameter);
  Io.enumCase(Enum, SymbolTypeKeys::Variable, SymbolType::Variable);
  Io.enumCase(Enum, SymbolTypeKeys::NamedFunction, SymbolType::NamedFunction);
  Io.enumCase(Enum, SymbolTypeKeys::Operator, SymbolType::Operator);
}

void MappingTraits<Symbol>::mapping(IO &Io, Symbol &Object) {
  Io.mapRequired("identifier", Object.Identifier);
  Io.mapRequired("name", Object.Name);
  Io.mapRequired("module", Object.Module);
  Io.mapRequired("type", Object.Type);
}

void MappingTraits<RenamesJson>::mapping(IO &Io, RenamesJson &Object) {
  Io.mapRequired("symbols", Object.Symbols);
}

void MappingTraits<SymbolRenaming>::mapping(IO &Io, SymbolRenaming &Object) {
  Io.mapRequired("identifier", Object.Identifier);
  Io.mapRequired("originalName", Object.OriginalName);
  Io.mapRequired("obfuscatedName", Object.ObfuscatedName);
  Io.mapRequired("module", Object.Module);
  Io.mapRequired("type", Object.Type);
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
  
template<class T>
Expected<T> deserialize(StringRef Json) {
  Input Input(Json);
  T Deserialized;
  Input >> Deserialized;
  if (auto ErrorCode = Input.error()) {
    return stringError("Error during JSON parse", ErrorCode);
  }
  return Deserialized;
}
  
template Expected<FilesJson> deserialize(StringRef Json);
template Expected<Project> deserialize(StringRef Json);
template Expected<ObfuscationModule> deserialize(StringRef Json);
template Expected<Sdk> deserialize(StringRef Json);
template Expected<ELF> deserialize(StringRef Json);
template Expected<SymbolsJson> deserialize(StringRef Json);
template Expected<Symbol> deserialize(StringRef Json);
template Expected<RenamesJson> deserialize(StringRef Json);
template Expected<SymbolRenaming> deserialize(StringRef Json);

} // namespace yaml
} // namespace llvm

namespace swift {
namespace json {

void ObjectTraits<SymbolsJson>::mapping(Output &Out, SymbolsJson &Object) {
  Out.mapRequired("symbols", Object.Symbols);
}
  
void ScalarEnumerationTraits<SymbolType>::enumeration(Output &Out,
                                                      SymbolType &Enum) {
  Out.enumCase(Enum, SymbolTypeKeys::Type, SymbolType::Type);
  Out.enumCase(Enum,
               SymbolTypeKeys::ExternalParameter,
               SymbolType::ExternalParameter);
  Out.enumCase(Enum,
               SymbolTypeKeys::InternalParameter,
               SymbolType::InternalParameter);
  Out.enumCase(Enum,
               SymbolTypeKeys::SingleParameter,
               SymbolType::SingleParameter);
  Out.enumCase(Enum, SymbolTypeKeys::Variable, SymbolType::Variable);
  Out.enumCase(Enum, SymbolTypeKeys::NamedFunction, SymbolType::NamedFunction);
  Out.enumCase(Enum, SymbolTypeKeys::Operator, SymbolType::Operator);
}

void ObjectTraits<Symbol>::mapping(Output &Out, Symbol &Object) {
  Out.mapRequired("name", Object.Name);
  Out.mapRequired("identifier", Object.Identifier);
  Out.mapRequired("module", Object.Module);
  Out.mapRequired("type", Object.Type);
}

void ObjectTraits<RenamesJson>::mapping(Output &Out, RenamesJson &Object) {
  Out.mapRequired("symbols", Object.Symbols);
}

void ObjectTraits<SymbolRenaming>::mapping(Output &Out,
                                           SymbolRenaming &Object) {
  Out.mapRequired("identifier", Object.Identifier);
  Out.mapRequired("originalName", Object.OriginalName);
  Out.mapRequired("obfuscatedName", Object.ObfuscatedName);
  Out.mapRequired("module", Object.Module);
  Out.mapRequired("type", Object.Type);
}

template<class T>
std::string serialize(T &Object) {
    std::string OutputString;
    llvm::raw_string_ostream OutputStringStream(OutputString);
    Output Output(OutputStringStream);
    Output << Object;
    return OutputStringStream.str();
}

template std::string serialize(SymbolsJson &Object);
template std::string serialize(Symbol &Object);
template std::string serialize(RenamesJson &Object);
template std::string serialize(SymbolRenaming &Object);

} // namespace json
} // namespace swift

