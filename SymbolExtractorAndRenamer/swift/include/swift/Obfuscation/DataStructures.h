#ifndef DataStructures_h
#define DataStructures_h

#include "llvm/Support/YAMLTraits.h"
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

struct Symbol {
  std::string Identifier;
  std::string Name;
  std::string Module;
  
  Symbol() = default;
  
  Symbol(const std::string &Identifier,
         const std::string &Name,
         const std::string &Module)
  : Identifier(Identifier), Name(Name), Module(Module) {};
  
  bool operator< (const Symbol &Right) const;
};

struct SymbolsJson {
  std::vector<Symbol> Symbols;
};

struct SymbolRenaming {
  std::string Identifier;
  std::string OriginalName;
  std::string ObfuscatedName;
  std::string Module;
  
  bool operator< (const SymbolRenaming &Right) const;
};

struct RenamesJson {
  std::vector<SymbolRenaming> Symbols;
};

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

} // namespace json
} // namespace swift

#endif /* DataStructures_h */
