#ifndef LayoutRenamer_h
#define LayoutRenamer_h

#include "swift/Obfuscation/DataStructures.h"
#include "swift/Obfuscation/Utils.h"
#include <vector>
#include <unordered_map>
#include <libxml2/libxml/parser.h>

namespace swift {
namespace obfuscation {

enum TargetRuntime {
  Undefined, CocoaTouch, Cocoa
};
  
enum TraversalDirection {
  Up, Down
};
  
/// Base class for renaming strategies. If a new layout file appears then
/// a new strategy should be created and applied to that new type of file.
/// Old files should use old strategies to ensure compatibility.
class BaseLayoutRenamingStrategy {
  protected:
    xmlNode *RootNode;
  
  /// Searches for a Node in the xml document starting from a given Node.
  ///
  /// \param Node a node where the search begins.
  /// \param AttributeName name of the attribute
  ///                      that the searched node should have.
  /// \param AttributeValue value of the attribute
  ///                       that the searched node should have.
  /// \param TraversalDirection which direction should
  ///                           the document be traversed in - Up or Down.
  ///
  /// \returns a Node if it exists or nullptr if not.
    xmlNode* findNodeWithAttributeValue(
                                   xmlNode *Node,
                                   const xmlChar *AttributeName,
                                   const xmlChar *AttributeValue,
                                   const TraversalDirection TraversalDirection);


public:
  virtual  void performActualRenaming(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) = 0;
  
  virtual  void renameCustomClass(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) = 0;
  
  virtual  void renameAction(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) = 0;
  
  virtual  void renameOutlet(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) = 0;
  
  BaseLayoutRenamingStrategy(xmlNode *RootNode);
  virtual ~BaseLayoutRenamingStrategy() = default;
};
  
class LayoutRenamer {

private:
  
  std::string FileName;
  
  xmlDoc *XmlDocument;
    
  llvm::Expected<std::unique_ptr<BaseLayoutRenamingStrategy>>
                                      createRenamingStrategy(xmlNode *RootNode);

public:

  LayoutRenamer(std::string FileName);

  /// Performs renaming of layout (.xib and .storyboard) files
  /// from FilesJson in the following steps:
  ///
  /// 1. Gathers all renamed symbols (see Renaming.h)
  ///    and stores them in RenamedSymbols map.
  /// 2. Iterates through FilesJson.LayoutFiles list
  ///    and picks renaming strategy based on file type and version.
  /// 3. Performs actual renaming if all conditions are met.
  /// 4. Saves renamed layout files in OutputPath.
  ///
  /// Typical usage:
  /// \code
  /// LayoutRenamer LayoutRenamer(LayoutFile); // param is a path to layout file
  ///
  /// auto RenamedOrError = LayoutRenamer.performRenaming(RenamedSymbols, Path);
  ///
  /// if (auto Error = RenamedOrError()) {
  ///   return std::move(Error);
  /// }
  ///
  /// auto PerformedRenaming = RenamedOrError();
  ///
  /// if (PerformedRenaming) {
  ///   ...
  /// }
  /// \endcode
  ///
  /// \param RenamedSymbols a map containing all renamed symbols
  ///                       in the source code.
  /// \param OutputPath Path where layout files will be saved after renaming.
  ///
  /// \returns true if file was renamed and false if it wasn't.
  llvm::Expected<bool> performRenaming(
                 std::unordered_map<std::string, SymbolRenaming> RenamedSymbols,
                 std::string OutputPath);

  ~LayoutRenamer();
};

} //namespace obfuscation
} //namespace swift

#endif /* LayoutRenamer_h */
