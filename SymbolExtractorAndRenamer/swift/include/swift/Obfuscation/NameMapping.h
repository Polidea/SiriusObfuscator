#ifndef NameMapping_h
#define NameMapping_h

#include "swift/Obfuscation/DataStructures.h"
#include "llvm/Support/Error.h"
#include "swift/Obfuscation/Random.h"
#include "swift/Obfuscation/Utils.h"

#include <string>
#include <vector>
#include <set>

namespace swift {
namespace obfuscation {

/// Name mapping strategies:
/// - Random generates unique random identifiers
/// - Deterministic generates predictible identifiers, we use it in tests
/// - Minifying generates shortes possible names
enum NameMappingStrategy {
  Random, Deterministic, Minifying
};
  
/// Base class for names generators.
class BaseIdentifierGenerator {
protected:
  static const std::vector<std::string> UniquelyTailSymbols;
  static const std::vector<std::string> HeadSymbols;
  static const std::vector<std::string> HeadOperatorSymbols;
  static const std::vector<std::string> UniquelyTailOperatorSymbols;
  
  std::map<SymbolType, std::string> SymbolShortNameMap = {
    { SymbolType::Type, "T" },
    { SymbolType::NamedFunction, "NF" },
    { SymbolType::SingleParameter, "SP" },
    { SymbolType::ExternalParameter, "EP" },
    { SymbolType::InternalParameter, "IP" },
    { SymbolType::Variable, "V" },
    { SymbolType::Operator, "O" }
  };
  
  std::map<SymbolType, std::map<std::string, int>> SymbolTypeMap = {
    { SymbolType::Type, {} },
    { SymbolType::NamedFunction, {} },
    { SymbolType::SingleParameter, {} },
    { SymbolType::ExternalParameter, {} },
    { SymbolType::InternalParameter, {} },
    { SymbolType::Variable, {} },
    { SymbolType::Operator, {} }
  };
  
  // taken from https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html
  std::set<std::string> SwiftKeywords = {
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
    "func", "import", "init", "inout", "internal", "let", "open", "operator",
    "private", "protocol", "public", "static", "struct", "subscript",
    "typealias", "var", "break", "case", "continue", "default", "defer", "do",
    "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return",
    "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil",
    "rethrows", "super", "self", "Self", "throw", "throws", "true", "try",
    "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix",
    "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional",
    "override", "postfix", "precedence", "prefix", "Protocol", "required",
    "right", "set", "Type", "unowned", "weak", "willSet"
  };
 
  static std::vector<std::string>
  concatenateSymbols(const std::vector<std::string> &Head,
                     const std::vector<std::string> &Tail);

public:
  virtual  llvm::Expected<std::string> generateName(const Symbol &Symbol) = 0;
  virtual ~BaseIdentifierGenerator() = default;
};
  
  
class NameMapping {

private:
  NameMappingStrategy NameMappingStrategy;
  std::unique_ptr<BaseIdentifierGenerator> IdentifierGenerator;
  std::unique_ptr<BaseIdentifierGenerator> OperatorGenerator;
  
  llvm::Expected<std::string> generateNameForSymbol(const Symbol &Symbol);
  
public:
  
  NameMapping(enum NameMappingStrategy NameMappingStrategy);
  
  /// Creates renamings for symbols found in SymbolsJson object.
  ///
  /// Rename generation depends on the type of the symbol found in SymbolsJson.
  /// Proposed new name for specific type must conform to [Swift Grammar]
  /// (https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AboutTheLanguageReference.html).
  /// Generated names are unique to ensure that no symbol name collisions will
  /// occur after renaming.
  ///
  /// Typical usage:
  /// \code
  /// // NameMappingStrategy is passed as an option when running the mapper
  /// // currently it can be "deterministic" or "random" (empty defaults to "random").
  /// NameMapping NameMapping(NameMappingStrategy);
  /// auto RenamingsOrError = NameMapping.proposeRenamings(SymbolsJson);
  /// if (auto Error = RenamingsOrError.takeError()) {
  ///   ExitOnError(std::move(Error));
  /// }
  /// auto Renamings = RenamingsOrError.get();
  /// \endcode
  ///
  /// \param SymbolsJson Symbols before renaming
  ///
  /// \returns Symbols with proposed renamings or error.
  /// Each SymbolRenaming object contains data of the symbol before renaming
  /// and proposed new name.
  llvm::Expected<RenamesJson> proposeRenamings(const SymbolsJson &SymbolsJson);
  
};

} //namespace obfuscation
} //namespace swift

#endif /* NameMapping_h */
