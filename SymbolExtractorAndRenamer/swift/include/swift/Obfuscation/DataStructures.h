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
};

struct Module {
  std::string Name;
};

struct Sdk {
  std::string Name;
  std::string Path;
};

struct ExplicitelyLinkedFrameworks {
  std::string Name;
  std::string Path;
};

struct FilesJson {
  Project Project;
  Module Module;
  Sdk Sdk;
  std::vector<std::string> Filenames;
  std::vector<std::string> SystemLinkedFrameworks;
  std::vector<ExplicitelyLinkedFrameworks> ExplicitelyLinkedFrameworks;
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
};
  
using SymbolsOrError = llvm::Expected<std::vector<SymbolWithRange>>;

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
struct MappingTraits<ExplicitelyLinkedFrameworks> {
  static void mapping(IO &Io, ExplicitelyLinkedFrameworks &Object);
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
