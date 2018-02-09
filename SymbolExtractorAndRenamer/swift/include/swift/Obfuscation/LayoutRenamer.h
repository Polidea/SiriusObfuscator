#ifndef LayoutRenamer_h
#define LayoutRenamer_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Utils.h"
#include <vector>
#include <unordered_map>
#include <libxml2/libxml/parser.h>

namespace swift {
namespace obfuscation {

/// Base class for renaming strategies. If a new layout file appears then
/// a new strategy should be created and applied to that new type of file.
/// Old files should use old strategies to ensure compatibility.
class BaseLayoutRenamingStrategy {
  
public:
  virtual  void performActualRenaming(xmlNode *Node, const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols, bool &performedRenaming) = 0;
  virtual ~BaseLayoutRenamingStrategy() = default;
};
  
class LayoutRenamer {

private:
  
  std::string FileName;
  
  xmlDoc *XmlDocument;
    
  llvm::Expected<std::unique_ptr<BaseLayoutRenamingStrategy>> createRenamingStrategy(xmlNode *RootNode);

public:

  LayoutRenamer(std::string FileName);

  /// Performs renaming of layout (.xib and .storyboard) files from FilesJson in the following steps:
  ///
  /// 1. Gathers all renamed symbols (see Renaming.h) and stores them in RenamedSymbols map.
  /// 2. Iterates through FilesJson.LayoutFiles list and picks renaming strategy based on file type and version.
  /// 3. Performs actual renaming if all conditions are met.
  /// 4. Saves renamed layout files in OutputPath.
  ///
  /// Typical usage:
  /// \code
  /// LayoutRenamer LayoutRenamer(LayoutFile); // param is a path to layout file
  ///
  /// auto PerformedRenamingOrError = LayoutRenamer.performRenaming(RenamedSymbols, Path);
  ///
  /// if (auto Error = PerformedRenamingOrError.takeError()) {
  ///   return std::move(Error);
  /// }
  ///
  /// auto PerformedRenaming = PerformedRenamingOrError.get();
  ///
  /// if (PerformedRenaming) {
  ///   ...
  /// }
  /// \endcode
  ///
  /// \param RenamedSymbols a map containing all renamed symbols in the source code.
  /// \param OutputPath Path where layout files will be saved after renaming.
  ///
  /// \returns true if file was renamed and false if it wasn't.
  llvm::Expected<bool> performRenaming(std::unordered_map<std::string, SymbolRenaming> RenamedSymbols, std::string OutputPath);

  ~LayoutRenamer();
};

} //namespace obfuscation
} //namespace swift

#endif /* LayoutRenamer_h */
