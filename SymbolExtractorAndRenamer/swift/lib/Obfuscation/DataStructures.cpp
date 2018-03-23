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

namespace ExclusionKindKeys {
  static std::string Type = "type";
  static std::string Inheritance = "inheritance";
  static std::string Conformance = "conformance";
}

const TypeExclusion* Exclusion::getAsTypeExclusion() const {
  return reinterpret_cast<const TypeExclusion*>(this);
}

const InheritanceExclusion* Exclusion::getAsInheritanceExclusion() const {
  return reinterpret_cast<const InheritanceExclusion*>(this);
}

const ConformanceExclusion* Exclusion::getAsConformanceExclusion() const {
  return reinterpret_cast<const ConformanceExclusion*>(this);
}

Symbol::Symbol(const std::string &Identifier,
       const std::string &Name,
       const std::string &Module,
       SymbolType Type)
  : Identifier(Identifier), Name(Name), Module(Module), Type(Type) {}

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
  if (Symbol < Right.Symbol) {
    return true;
  } else if (Right.Symbol < Symbol) {
    return false;
  } else {
    auto less = std::less<const char *>();
    if (const auto* RangeValuePointer = pointerToRangeValue(*this)) {
      if (const auto* RightRangeValuePointer = pointerToRangeValue(Right)) {
        auto isRangeLess = less(RangeValuePointer, RightRangeValuePointer);
        return isRangeLess;
      }
    }
  }
  assert(false && "Comparing Symbols with Ranges requires Ranges Start "
                  "Location Values Pointers to be of const char type");
}

bool SymbolWithRange::operator== (const SymbolWithRange &Right) const {
  if (const auto* RangeValuePointer = pointerToRangeValue(*this)) {
    if (const auto* RightRangeValuePointer = pointerToRangeValue(Right)) {
      return Symbol == Right.Symbol
          && RangeValuePointer == RightRangeValuePointer;
    }
  }
  return false;
}

IndexedSymbolWithRange::
  IndexedSymbolWithRange(const int Index,
                         const struct SymbolWithRange &SymbolWithRange)
: Index(Index), SymbolWithRange(SymbolWithRange) {}

bool IndexedSymbolWithRange::SymbolCompare::
  operator() (const IndexedSymbolWithRange& Left,
              const IndexedSymbolWithRange& Right) const {
  return Left.SymbolWithRange.Symbol < Right.SymbolWithRange.Symbol;
}

bool IndexedSymbolWithRange::SymbolWithRangeCompare::
  operator() (const IndexedSymbolWithRange& Left,
              const IndexedSymbolWithRange& Right) const {
  return Left.SymbolWithRange < Right.SymbolWithRange;
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
  Io.mapRequired("implicitlyLinkedFrameworks",
                 Object.ImplicitlyLinkedFrameworks);
  Io.mapRequired("explicitlyLinkedFrameworks",
                 Object.ExplicitlyLinkedFrameworks);
  Io.mapRequired("frameworkSearchPaths",
                 Object.FrameworkSearchPaths);
  Io.mapRequired("headerSearchPaths",
                 Object.HeaderSearchPaths);
  Io.mapRequired("configurationFile", Object.ConfigurationFile);
  Io.mapRequired("bridgingHeader",
                 Object.BridgingHeader);
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

void MappingTraits<ObfuscationConfiguration>::
  mapping(IO &Io, ObfuscationConfiguration &Object) {
  Io.mapRequired("exclude", Object.Exclude);
}

void ScalarEnumerationTraits<ExclusionKind>::enumeration(IO &Io,
                                                         ExclusionKind &Enum) {
  Io.enumCase(Enum, ExclusionKindKeys::Type.c_str(), ExclusionKind::Type);
  Io.enumCase(Enum,
              ExclusionKindKeys::Inheritance.c_str(),
              ExclusionKind::Inheritance);
  Io.enumCase(Enum,
              ExclusionKindKeys::Conformance.c_str(),
              ExclusionKind::Conformance);
}

void MappingTraits<std::unique_ptr<Exclusion>>::
  mapping(IO &Io, std::unique_ptr<Exclusion> &Object) {
  auto CurrentlyProcessedKey = Io.keys().back().str();

  if (CurrentlyProcessedKey == ExclusionKindKeys::Type) {
    auto Type = llvm::make_unique<TypeExclusion>();
    Io.mapRequired(CurrentlyProcessedKey.c_str(), *Type);
    Object = std::move(Type);
    return;
  }

  if (CurrentlyProcessedKey == ExclusionKindKeys::Inheritance) {
    auto Inheritance = llvm::make_unique<InheritanceExclusion>();
    Io.mapRequired(CurrentlyProcessedKey.c_str(), *Inheritance);
    Object = std::move(Inheritance);
    return;
  }

  if (CurrentlyProcessedKey == ExclusionKindKeys::Conformance) {
    auto Conformance = llvm::make_unique<ConformanceExclusion>();
    Io.mapRequired(CurrentlyProcessedKey.c_str(), *Conformance);
    Object = std::move(Conformance);
    return;
  }
}

void MappingTraits<TypeExclusion>::mapping(IO &Io, TypeExclusion &Object) {
  Object.Kind = ExclusionKind::Type;
  Io.mapRequired("module", Object.Module);
  Io.mapRequired("name", Object.Name);
}

void MappingTraits<InheritanceExclusion>::
  mapping(IO &Io, InheritanceExclusion &Object) {
    Object.Kind = ExclusionKind::Inheritance;
    Io.mapRequired("module", Object.Module);
    Io.mapRequired("transitive", Object.Transitive);
    Io.mapRequired("base", Object.Base);
}

void MappingTraits<ConformanceExclusion>::
  mapping(IO &Io, ConformanceExclusion &Object) {
    Object.Kind = ExclusionKind::Conformance;
    Io.mapRequired("module", Object.Module);
    Io.mapRequired("transitive", Object.Transitive);
    Io.mapRequired("protocol", Object.Protocol);
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
    return std::move(stringError("Error during JSON parse", ErrorCode));
  }
  return std::move(Deserialized);
}
  
template Expected<FilesJson> deserialize(StringRef Json);
template Expected<ObfuscationConfiguration> deserialize(StringRef Json);
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

