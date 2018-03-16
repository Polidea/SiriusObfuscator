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

struct LayoutNodeRenaming {
  xmlNode *Node;
  const xmlChar* PropertyName;
  const std::string ObfuscatedName;
  
  LayoutNodeRenaming() = default;
  
  LayoutNodeRenaming(xmlNode* Node,
                     const xmlChar* PropertyName,
                     const std::string ObfuscatedName);
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
  virtual void
          extractLayoutRenamingNodes(
                      xmlNode *Node,
                      const std::vector<SymbolRenaming> &RenamedSymbols,
                      std::vector<LayoutNodeRenaming> &NodesToRename) = 0;
  
  virtual llvm::Optional<LayoutNodeRenaming> extractCustomClassRenamingNode(
          xmlNode *Node,
          const std::vector<SymbolRenaming> &RenamedSymbols) = 0;
  
  virtual llvm::Optional<LayoutNodeRenaming> extractActionRenamingNode(
          xmlNode *Node,
          const std::vector<SymbolRenaming> &RenamedSymbols) = 0;
  
  virtual llvm::Optional<LayoutNodeRenaming> extractOutletRenamingNode(
          xmlNode *Node,
          const std::vector<SymbolRenaming> &RenamedSymbols) = 0;
  
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

  /// Extracts node info required for renaming of layout
  /// (.xib and .storyboard) files from FilesJson in the following steps:
  ///
  /// 1. Gathers all renamed symbols (see Renaming.h)
  ///    and stores them in RenamedSymbols vector.
  /// 2. Iterates through FilesJson.LayoutFiles list
  ///    and picks renaming strategy based on file type and version.
  /// 3. Extracts all node info that should be renamed.
  /// 3. Performs actual renaming.
  /// 4. Saves renamed layout files in OutputPath.
  ///
  /// Typical usage:
  /// \code
  /// LayoutRenamer LayoutRenamer(LayoutFile); // param is a path to layout file
  ///
  /// // Extract nodes
  /// auto NodesToRenameOrError
  ///                = LayoutRenamer.extractLayoutRenamingNodes(RenamedSymbols);
  ///
  /// if (auto Error = NodesToRenameOrError.takeError()) {
  ///   return std::move(Error);
  /// }
  ///
  /// auto NodesToRename = NodesToRenameOrError.get();
  ///
  /// // Perform renaming on extracted nodes
  /// if (!NodesToRename.empty()) {
  ///   LayoutRenamer.performRenaming(NodesToRename, Path);
  /// }
  ///
  /// \endcode
  ///
  /// \param RenamedSymbols a vector containing all renamed symbols
  ///                       in the source code.
  ///
  /// \returns a vector containing all node info required to preform renaming.
  llvm::Expected<std::vector<LayoutNodeRenaming>>
  extractLayoutRenamingNodes(std::vector<SymbolRenaming> RenamedSymbols);
  
  /// Performs actual renaming of layout files
  /// \param LayoutNodesToRename a vector containing all node info
  ///                            required to preform renaming.
  /// \param OutputPath Path where layout files will be saved after renaming.
  void performRenaming(
                 const std::vector<LayoutNodeRenaming> LayoutNodesToRename,
                 std::string OutputPath);
  
  

  ~LayoutRenamer();
};

} //namespace obfuscation
} //namespace swift

#endif /* LayoutRenamer_h */
