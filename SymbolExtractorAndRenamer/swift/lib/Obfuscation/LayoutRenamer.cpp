#include "swift/Obfuscation/LayoutRenamer.h"

namespace swift {
namespace obfuscation {

class XCode9RenamingStrategy: public BaseLayoutRenamingStrategy {

private:
  
  bool shouldRename(const SymbolRenaming &Symbol, const std::string &CustomClass, const std::string &CustomModule) {
    return CustomModule.empty() || CustomModule == Symbol.Module;
  }
  
public:
  
  /// Performs renames if needed based on RenamedSymbols map. Layout files are xmls, it looks for a specific attributes
  /// such as "customClass" and retrieves their values. These values are then used to
  /// look up RenamedSymbols map. If a "customClass" value is present inside RenamedSymbols, then
  /// it means that this symbol was renamed in the source code in previous step and it should be
  /// renamed in layout file as well. "customModule" attribute is also taken into account - if it's
  /// present then it's value is compared with symbol's module value (the one found in RenamedSymbols) and
  /// if it's not present then we assume that it's inherited from target project.
  void performActualRenaming(xmlNode *Node, const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols, bool &performedRenaming) {
    const auto *CustomClassAttributeName = reinterpret_cast<const xmlChar *>("customClass");
    const auto *CustomModuleAttributeName = reinterpret_cast<const xmlChar *>("customModule");
    
    for (xmlNode *CurrentNode = Node; CurrentNode != nullptr; CurrentNode = CurrentNode->next) {
      
      if (CurrentNode->type == XML_ELEMENT_NODE) {
        
        std::string CustomClass;
        std::string CustomModule;
        
        for (xmlAttr *CurrentAttribute = CurrentNode->properties; CurrentAttribute != nullptr; CurrentAttribute = CurrentAttribute->next) {
          
          if(CurrentAttribute->type == XML_ATTRIBUTE_NODE) {
            
            if ((!xmlStrcmp(CurrentAttribute->name, CustomClassAttributeName))) {
              CustomClass = std::string(reinterpret_cast<const char *>(xmlGetProp(CurrentNode, CurrentAttribute->name)));
            }
            
            if ((!xmlStrcmp(CurrentAttribute->name, CustomModuleAttributeName))) {
              CustomModule = std::string(reinterpret_cast<const char *>(xmlGetProp(CurrentNode, CurrentAttribute->name)));
            }
          }
          
          if(!CustomClass.empty()) {
            
            auto SymbolIterator = RenamedSymbols.find(CustomClass);
            
            if ( SymbolIterator != RenamedSymbols.end() ) {
              
              auto Symbol = SymbolIterator->second;
              
              if(shouldRename(Symbol, CustomClass, CustomModule)) {
                xmlSetProp(CurrentNode, CustomClassAttributeName, reinterpret_cast<const xmlChar *>(Symbol.ObfuscatedName.c_str()));
                performedRenaming = true;
              }
            }
            
            CustomClass.clear();
            CustomModule.clear();
          }
        }
      }
      
      performActualRenaming(CurrentNode->children, RenamedSymbols, performedRenaming);
    }
  }
};
  
LayoutRenamer::LayoutRenamer(std::string FileName) {
  this->FileName = FileName;
  XmlDocument = xmlReadFile(FileName.c_str(), /* encoding */ "UTF-8", /* options */ 0);
}

LayoutRenamer::~LayoutRenamer() {
  if(XmlDocument != nullptr) {
    xmlFreeDoc(XmlDocument);
  }
  xmlCleanupParser();
}

// For now we support layout files with root node that looks like this:
// <document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" ... >
// where type can be Cocoa or CocoaTouch .XIB or .Storyboard.XIB
llvm::Expected<std::unique_ptr<BaseLayoutRenamingStrategy>> LayoutRenamer::createRenamingStrategy(xmlNode *RootNode) {
  const auto *RootNodeName = reinterpret_cast<const xmlChar *>("document");
  
  if ((!xmlStrcmp(RootNode->name, RootNodeName))) {
    
    const auto *RootNodeTypeAttributeName = reinterpret_cast<const xmlChar *>("type");
    const auto *RootNodeVersionAttributeName = reinterpret_cast<const xmlChar *>("version");
    
    auto TypeAttributeValue = std::string(reinterpret_cast<const char *>(xmlGetProp(RootNode, RootNodeTypeAttributeName)));
    auto VersionAttributeValue = std::string(reinterpret_cast<const char *>(xmlGetProp(RootNode, RootNodeVersionAttributeName)));

    std::set<std::string> SupportedDocumentTypes = {
      "com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB",
      "com.apple.InterfaceBuilder3.Cocoa.Storyboard.XIB",
      "com.apple.InterfaceBuilder3.CocoaTouch.XIB",
      "com.apple.InterfaceBuilder3.Cocoa.XIB"
    };
    
    if(SupportedDocumentTypes.find(TypeAttributeValue) != SupportedDocumentTypes.end() && VersionAttributeValue == "3.0") {
      return llvm::make_unique<XCode9RenamingStrategy>();
    } else {

      // Probably a new version of layout file came out and it should be handled separately.
      // Create a new BaseLayoutRenamingStrategy implementation and update this method so
      // it returns correct Strategy for specific version of the layout file.
      return stringError("Unknown layout file version for layout: " + FileName);
    }
  } else {
     return stringError("Unknown root node type in layout file: " + FileName);
  }
}

llvm::Expected<bool> LayoutRenamer::performRenaming(std::unordered_map<std::string, SymbolRenaming> RenamedSymbols, std::string OutputPath) {

  if (XmlDocument == nullptr) {
    return stringError("Could not parse file: " + FileName);
  }
  
  xmlNode *RootNode = xmlDocGetRootElement(XmlDocument);
  
  auto RenamingStrategyOrError = createRenamingStrategy(RootNode);
  
  if (auto Error = RenamingStrategyOrError.takeError()) {
    return std::move(Error);
  }
  
  auto RenamingStrategy = std::move(RenamingStrategyOrError.get());
  
  bool performedRenaming = false;
  RenamingStrategy->performActualRenaming(RootNode, RenamedSymbols, performedRenaming);
  
  xmlSaveFileEnc(static_cast<const char *>(OutputPath.c_str()), XmlDocument, reinterpret_cast<const char *>(XmlDocument->encoding));
  
  return performedRenaming;
}
        
} //namespace obfuscation
} //namespace swift
