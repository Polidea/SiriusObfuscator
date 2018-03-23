#ifndef DataStructures_h
#define DataStructures_h

#include "swift/Frontend/Frontend.h"
#include "llvm/Support/YAMLTraits.h"
#include "llvm/Support/Error.h"
#include "swift/Basic/JSONSerialization.h"

#include <vector>
#include <string>

namespace swift {
namespace obfuscation {
  
struct Project {
  std::string RootPath;
  std::string ProjectFilePath;
};

struct Module {
  std::string Name;
  std::string TargetTriple;
};

struct Sdk {
  std::string Name;
  std::string Path;
};

struct ExplicitlyLinkedFrameworks {
  std::string Name;
  std::string Path;
};

struct FilesJson {
  Project Project;
  Module Module;
  Sdk Sdk;
  std::vector<std::string> SourceFiles;
  std::vector<std::string> LayoutFiles;
  std::vector<std::string> ImplicitlyLinkedFrameworks;
  std::vector<ExplicitlyLinkedFrameworks> ExplicitlyLinkedFrameworks;
  std::vector<std::string> FrameworkSearchPaths;
  std::vector<std::string> HeaderSearchPaths;
  std::string BridgingHeader;
  std::string ConfigurationFile;
};

enum class SymbolType: int {
  
  Type,
  
  NamedFunction,
  
  SingleParameter,
  
  ExternalParameter,
  
  InternalParameter,
  
  Variable,
  
  Operator
  
};

struct Symbol {
  std::string Identifier;
  std::string Name;
  std::string Module;
  SymbolType Type;
  
  Symbol() = default;
  
  Symbol(const std::string &Identifier,
         const std::string &Name,
         const std::string &Module,
         SymbolType Type);
  
  bool operator< (const Symbol &Right) const;
  bool operator== (const Symbol &Right) const;
};
  
using SingleSymbolOrError = llvm::Expected<Symbol>;

struct SymbolsJson {
  std::vector<Symbol> Symbols;
};

struct SymbolRenaming {
  std::string Identifier;
  std::string OriginalName;
  std::string ObfuscatedName;
  std::string Module;
  SymbolType Type;
  
  SymbolRenaming() = default;
  
  SymbolRenaming(const std::string &Identifier,
         const std::string &OriginalName,
         const std::string &ObfuscatedName,
         const std::string &Module,
         SymbolType Type);
  
  bool operator== (const SymbolRenaming &Right) const;
};

struct RenamesJson {
  std::vector<SymbolRenaming> Symbols;
};

enum class ExclusionKind: int {
  UnknownKind,

  Type,

  Inheritance,

  Conformance
};

struct TypeExclusion;
struct InheritanceExclusion;
struct ConformanceExclusion;

struct Exclusion {

  std::string Module;

  ExclusionKind Kind;

  const TypeExclusion* getAsTypeExclusion() const;
  const InheritanceExclusion* getAsInheritanceExclusion() const;
  const ConformanceExclusion* getAsConformanceExclusion() const;
};

struct TypeExclusion: public Exclusion {
  std::string Name;

  TypeExclusion() = default;
  TypeExclusion(const TypeExclusion&) = default;
  TypeExclusion(TypeExclusion&&) = default;
};

struct InheritanceExclusion: public Exclusion {
  std::string Base;
  bool Transitive;

  InheritanceExclusion() = default;
  InheritanceExclusion(const InheritanceExclusion&) = default;
  InheritanceExclusion(InheritanceExclusion&&) = default;
};

struct ConformanceExclusion: public Exclusion {
  std::string Protocol;
  bool Transitive;

  ConformanceExclusion() = default;
  ConformanceExclusion(const ConformanceExclusion&) = default;
  ConformanceExclusion(ConformanceExclusion&&) = default;
};

struct ObfuscationConfiguration {
  std::vector<std::unique_ptr<Exclusion>> Exclude;

  ObfuscationConfiguration() = default;
  ObfuscationConfiguration(const ObfuscationConfiguration&) = delete;
  ObfuscationConfiguration(ObfuscationConfiguration&&) = default;
  ObfuscationConfiguration& operator=(const ObfuscationConfiguration &) = delete;
  ObfuscationConfiguration& operator=(ObfuscationConfiguration &&) = default;
};
  
/// SymbolWithRange - struct for linking the symbol identified in the Swift
/// source code with the range in which it was encountered.
struct SymbolWithRange {
  Symbol Symbol;
  CharSourceRange Range;
  
  /// @brief Trivial memberwise-like constructor
  SymbolWithRange(const swift::obfuscation::Symbol &Symbol,
                  const CharSourceRange &Range);
  
  /// @brief Comparison operator required for containing SymbolWithRange in
  /// sets. It's taking into consideration both symbol identifier and range.
  bool operator< (const SymbolWithRange &Right) const;

  bool operator== (const SymbolWithRange &Right) const;
};

struct IndexedSymbolWithRange {
  int Index;
  SymbolWithRange SymbolWithRange;

  /// @brief Trivial memberwise-like constructor
  IndexedSymbolWithRange(const int Index,
                         const struct SymbolWithRange &SymbolWithRange);

  /// @brief Comparison required for containing IndexedSymbolWithRange in sets.
  /// It's taking only symbol into consideration, not range nor index.
  struct SymbolCompare {
    bool operator() (const IndexedSymbolWithRange& Left,
                     const IndexedSymbolWithRange& Right) const;
  };

  /// @brief Comparison required for containing IndexedSymbolWithRange in sets.
  /// It's taking only symbol with range into consideration, not index.
  struct SymbolWithRangeCompare {
    bool operator() (const IndexedSymbolWithRange& Left,
                     const IndexedSymbolWithRange& Right) const;
  };
};

using SingleSymbolOrError = llvm::Expected<Symbol>;
  
using SymbolsOrError = llvm::Expected<std::vector<SymbolWithRange>>;

using GlobalCollectedSymbols = std::set<IndexedSymbolWithRange,
                                IndexedSymbolWithRange::SymbolWithRangeCompare>;
} //namespace obfuscation
} //namespace swift

using namespace swift::obfuscation;

// MARK: - Deserialization

namespace llvm {
namespace yaml {

template <>
struct MappingTraits<FilesJson> {
  static void mapping(IO &Io, FilesJson &Object);
};
  
template <>
struct MappingTraits<Project> {
  static void mapping(IO &Io, Project &Object);
};

template <>
struct MappingTraits<swift::obfuscation::Module> {
  static void mapping(IO &Io, swift::obfuscation::Module &Object);
};

template <>
struct MappingTraits<Sdk> {
  static void mapping(IO &Io, Sdk &Object);
};

template <>
struct MappingTraits<ExplicitlyLinkedFrameworks> {
  static void mapping(IO &Io, ExplicitlyLinkedFrameworks &Object);
};

template <>
struct MappingTraits<SymbolsJson> {
  static void mapping(IO &Io, SymbolsJson &Object);
};
  
template <>
struct ScalarEnumerationTraits<SymbolType> {
  static void enumeration(IO &Io, SymbolType &Enum);
};

template <>
struct MappingTraits<Symbol> {
  static void mapping(IO &Io, Symbol &Object);
};

template <>
struct MappingTraits<RenamesJson> {
  static void mapping(IO &Io, RenamesJson &Object);
};

template <>
struct MappingTraits<SymbolRenaming> {
  static void mapping(IO &Io, SymbolRenaming &Object);
};

template <>
struct MappingTraits<ObfuscationConfiguration> {
  static void mapping(IO &Io, ObfuscationConfiguration &Object);
};

template <>
struct ScalarEnumerationTraits<ExclusionKind> {
  static void enumeration(IO &Io, ExclusionKind &Enum);
};

template <>
struct MappingTraits<std::unique_ptr<Exclusion>> {
  static void mapping(IO &Io, std::unique_ptr<Exclusion> &Object);
};

template <>
struct MappingTraits<TypeExclusion> {
  static void mapping(IO &Io, TypeExclusion &Object);
};

template <>
struct MappingTraits<InheritanceExclusion> {
  static void mapping(IO &Io, InheritanceExclusion &Object);
};

template <>
struct MappingTraits<ConformanceExclusion> {
  static void mapping(IO &Io, ConformanceExclusion &Object);
};

template <typename U>
struct SequenceTraits<std::vector<U>> {
  static size_t size(IO &Io, std::vector<U> &Vec);
  static U &element(IO &Io, std::vector<U> &Vec, size_t Index);
};
  
template<class T>
Expected<T> deserialize(StringRef Json);

} // namespace yaml
} // namespace llvm

// MARK: - Serialization

namespace swift {
namespace json  {

template <>
struct ObjectTraits<SymbolsJson> {
  static void mapping(Output &Out, SymbolsJson &Object);
};
  
template <>
struct ScalarEnumerationTraits<SymbolType> {
  static void enumeration(Output &Out, SymbolType &Enum);
};

template <>
struct ObjectTraits<Symbol> {
  static void mapping(Output &Out, Symbol &Object);
};

template <>
struct ObjectTraits<RenamesJson> {
  static void mapping(Output &Out, RenamesJson &Object);
};

template <>
struct ObjectTraits<SymbolRenaming> {
  static void mapping(Output &Out, SymbolRenaming &Object);
};

template<class T>
std::string serialize(T &Object);

} // namespace json
} // namespace swift

#endif /* DataStructures_h */
