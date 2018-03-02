#include "swift/Obfuscation/LayoutRenamer.h"

namespace swift {
namespace obfuscation {
  
BaseLayoutRenamingStrategy::BaseLayoutRenamingStrategy(xmlNode *RootNode)
  : RootNode(RootNode) {}
  
  
  
xmlNode*
BaseLayoutRenamingStrategy::findNodeWithAttributeValue(
                                  xmlNode *Node,
                                  const xmlChar *AttributeName,
                                  const xmlChar *AttributeValue,
                                  const TraversalDirection TraversalDirection) {
  
  if(Node == nullptr || AttributeName == nullptr) {
    return nullptr;
  }
  
  for (xmlNode *CurrentNode = Node;
       CurrentNode != nullptr;
       CurrentNode = CurrentNode->next) {
    
    if (CurrentNode->type == XML_ELEMENT_NODE) {
      
      for (xmlAttr *CurrentAttribute = CurrentNode->properties;
           CurrentAttribute != nullptr;
           CurrentAttribute = CurrentAttribute->next) {
        
        if(CurrentAttribute->type == XML_ATTRIBUTE_NODE) {
            
          if(xmlStrcmp(CurrentAttribute->name, AttributeName) == 0){
            // if AttributeValue == nullptr then it means that we're interested
            // in finding only a Node with attribute that name is AttributeName
            if(AttributeValue == nullptr) {
              return CurrentNode;
            } else {
              // otherwise we need to pull attribute's value and compare it
              // with AttributeValue that was passed as a parameter
              xmlChar* value = xmlGetProp(CurrentNode, AttributeName);
              if(xmlStrcmp(value, AttributeValue) == 0){
                return CurrentNode;
              }
            }
          }
        }
      }
    }
    
    // depending on the TraversalDirection we go down (children)
    // or up (parent) of the document
    xmlNode *NextNode = nullptr;
    if(TraversalDirection == Up) {
      NextNode = CurrentNode->parent;
    } else if(TraversalDirection == Down) {
      NextNode = CurrentNode->children;
    }
    
    if(NextNode != nullptr) {
      xmlNode *Found = findNodeWithAttributeValue(NextNode,
                                                   AttributeName,
                                                   AttributeValue,
                                                   TraversalDirection);
      if(Found != nullptr) {
        return Found;
      }
    }
  }
  
  return nullptr;
}

class XCode9RenamingStrategy: public BaseLayoutRenamingStrategy {

private:
  // Needed for type renaming
  const xmlChar *
  CustomClassAttributeName = reinterpret_cast<const xmlChar *>("customClass");
  
  const xmlChar *
  CustomModuleAttributeName = reinterpret_cast<const xmlChar *>("customModule");
  
  // Needed for outlet renaming
  const xmlChar *
  OutletNodeName = reinterpret_cast<const xmlChar *>("outlet");
  
  const xmlChar *
  OutletPropertyAttributeName = reinterpret_cast<const xmlChar *>("property");
  
  // Needed for action renaming
  const xmlChar *
  ActionNodeName = reinterpret_cast<const xmlChar *>("action");
  
  const xmlChar *
  ActionSelectorAttributeName = reinterpret_cast<const xmlChar *>("selector");
  
  //General
  const xmlChar *
  IdAttributeName = reinterpret_cast<const xmlChar *>("id");
  
  const xmlChar *
  DestinationAttributeName = reinterpret_cast<const xmlChar *>("destination");
  
  const xmlChar *
  TargetAttributeName = reinterpret_cast<const xmlChar *>("target");
  
  TargetRuntime TargetRuntime;

  bool shouldRename(const SymbolRenaming &Symbol,
                    const std::string &CustomClass,
                    const std::string &CustomModule) {
    return CustomModule.empty() || CustomModule == Symbol.Module;
  }
  
  void extractCustomClassAndModule(xmlNode *Node,
                                   std::string &CustomClass,
                                   std::string &CustomModule) {
    
    for (xmlAttr *CurrentAttribute = Node->properties;
         CurrentAttribute != nullptr;
         CurrentAttribute = CurrentAttribute->next) {
      
      if(CurrentAttribute->type == XML_ATTRIBUTE_NODE) {
        
        if (xmlStrcmp(CurrentAttribute->name, CustomClassAttributeName) == 0) {
          CustomClass = std::string(reinterpret_cast<const char *>(xmlGetProp(
                                                      Node,
                                                      CurrentAttribute->name)));
        }
        
        if (xmlStrcmp(CurrentAttribute->name, CustomModuleAttributeName) == 0) {
          CustomModule = std::string(reinterpret_cast<const char *>(xmlGetProp(
                                                      Node,
                                                      CurrentAttribute->name)));
        }
      }
    }
  }
  
public:
  
  XCode9RenamingStrategy(xmlNode *RootNode, enum TargetRuntime TargetRuntime)
  : BaseLayoutRenamingStrategy(RootNode) {
    this->TargetRuntime = TargetRuntime;
  }
  
  // Performs renames if needed based on RenamedSymbols map.
  // Layout files are xmls, it looks for a specific attributes
  // such as "customClass" and retrieves their values.
  // These values are then used to look up RenamedSymbols map.
  // If a "customClass" value is present inside RenamedSymbols, then
  // it means that this symbol was renamed in the source code in previous step
  // and it should be renamed in layout file as well.
  // "customModule" attribute is also taken into account - if it's present then
  // it's value is compared with
  // symbol's module value (the one found in RenamedSymbols) and
  // if it's not present then we assume that it's inherited from target project.
  void performActualRenaming(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) {
    
    if(Node == nullptr){
      return;
    }
    
    for (xmlNode *CurrentNode = Node;
         CurrentNode != nullptr;
         CurrentNode = CurrentNode->next) {
      
      if (CurrentNode->type == XML_ELEMENT_NODE) {
        renameCustomClass(CurrentNode, RenamedSymbols, PerformedRenaming);
        renameAction(CurrentNode, RenamedSymbols, PerformedRenaming);
        renameOutlet(CurrentNode, RenamedSymbols, PerformedRenaming);
      }
      
      xmlNode *ChildrenNode = CurrentNode->children;
      if(ChildrenNode != nullptr) {
        performActualRenaming(ChildrenNode, RenamedSymbols, PerformedRenaming);
      }
    }
  }
  
  void renameCustomClass(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) {
    
    std::string CustomClass;
    std::string CustomModule;
    
    extractCustomClassAndModule(Node, CustomClass, CustomModule);
    
    if(!CustomClass.empty()) {
      
      auto SymbolIterator = RenamedSymbols.find(CustomClass);
      
      if ( SymbolIterator != RenamedSymbols.end() ) {
        
        auto Symbol = SymbolIterator->second;
        
        if(shouldRename(Symbol, CustomClass, CustomModule)) {
          xmlSetProp(Node,
                     CustomClassAttributeName,
                     reinterpret_cast<const xmlChar *>(
                                                Symbol.ObfuscatedName.c_str()));
          PerformedRenaming = true;
        }
      }
    }
  }
  
  // actions look like this in xml for macos:
  // <action selector="customAction:" target="XfG-lQ-9wD" id="UKD-iL-45N"/>
  //
  // and like this in xml for ios:
  // <action selector="customAction:" destination="0Ct-JR-NLr" eventType="touchUpInside" id="s2s-A5-aG6"/>
  //
  // in order to obfuscate customAction the module name needs to be known
  // it looks for a node which id attribute's value is equal to
  // actions's node destination (or target if destination
  // is not present) attribute value
  // then it extracts CustomClass/CustomModule needed for check
  // if customAction should be obfuscated
  // it does the check and performs renaming if needed
  void renameAction(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) {
    
    if (xmlStrcmp(Node->name, ActionNodeName) == 0) {
      
      std::string DestinationOrTarget;
      
      if(TargetRuntime == CocoaTouch) {
        DestinationOrTarget = std::string(
                              reinterpret_cast<const char *>(
                                                    xmlGetProp(Node,
                                                    DestinationAttributeName)));
        
      } else if(TargetRuntime == Cocoa) {
        DestinationOrTarget = std::string(
                              reinterpret_cast<const char *>(
                                                     xmlGetProp(Node,
                                                    TargetAttributeName)));
      }
      
      // find node with which id attribute value == DestinationOrTarget
      xmlNode *NodeWithDestinationAsId = findNodeWithAttributeValue(
                           RootNode,
                           IdAttributeName,
                           reinterpret_cast<const xmlChar *>
                                                  (DestinationOrTarget.c_str()),
                           TraversalDirection::Down);
      
      if(NodeWithDestinationAsId != nullptr) {
        
        std::string CustomClass;
        std::string CustomModule;
        
        // Try to extract CustomClass and CustomModule
        extractCustomClassAndModule(
                                    NodeWithDestinationAsId,
                                    CustomClass,
                                    CustomModule);
        
        // Check if should rename and if yes then perform actual renaming
        if(!CustomClass.empty()) {
          
          std::string SelectorName = std::string(
                                     reinterpret_cast<const char *>(xmlGetProp(
                                                 Node,
                                                 ActionSelectorAttributeName)));
          
          std::vector<std::string> SplittedSelName = split(SelectorName, ':');
          if(!SplittedSelName.empty()) {
          
            std::string SelectorFunctionName = SplittedSelName[0];
            
            auto SymbolIterator = RenamedSymbols.find(SelectorFunctionName);
            
            if ( SymbolIterator != RenamedSymbols.end() ) {
              
              auto Symbol = SymbolIterator->second;
              
              SelectorName.replace(0,
                                   Symbol.OriginalName.length(),
                                   Symbol.ObfuscatedName);
              
              if(shouldRename(Symbol, CustomClass, CustomModule)) {
                xmlSetProp(Node,
                           ActionSelectorAttributeName,
                           reinterpret_cast<const xmlChar *>(
                                                         SelectorName.c_str()));
                
                PerformedRenaming = true;
              }
            }
          }
        }
      }
    }
  }
  
  // outlets look like this in xml:
  // <outlet property="prop_name" destination="x0y-zc-UQE" id="IiG-Jc-DUb"/>
  //
  // in order to obfuscate prop_name the module name needs to be known
  // first it looks for a node which id attribute's value is equal
  // to outlet's node destination attribute value
  // if it finds such node then it checks if it has
  // CustomClass and CustomModule attributes
  // if not then it means that it's probably somewhere higher in the hierarchy
  // so it looks for the closest parent which has CustomClass attribute
  // then when it finally have CustomClass/CustomModule needed for check
  // if prop_name should be obfuscated
  // it does the check and performs renaming if needed
  void renameOutlet(
          xmlNode *Node,
          const std::unordered_map<std::string, SymbolRenaming> &RenamedSymbols,
          bool &PerformedRenaming) {
    
    if (xmlStrcmp(Node->name, OutletNodeName) == 0) {
      
      std::string Destination = std::string(
                                reinterpret_cast<const char *>(xmlGetProp(
                                                    Node,
                                                    DestinationAttributeName)));
      
      // find node with which id attribute value == Destination
      xmlNode *NodeWithDestinationAsId = findNodeWithAttributeValue(
                                  RootNode,
                                  IdAttributeName,
                                  reinterpret_cast<const xmlChar *>
                                                          (Destination.c_str()),
                                  TraversalDirection::Down);
      
      if(NodeWithDestinationAsId != nullptr) {
        
        std::string CustomClass;
        std::string CustomModule;
        
        // Try to extract CustomClass and CustomModule
        extractCustomClassAndModule(NodeWithDestinationAsId,
                                    CustomClass,
                                    CustomModule);
        
        // find CustomClass attribute value to check
        // if outlet name should be renamed
        if(CustomClass.empty()) {
          
          //CustomClass was not present in a Node where id == Destination
          // so search for closest parent Node with custom class
          xmlNode *Parent = findNodeWithAttributeValue(
                                                      NodeWithDestinationAsId,
                                                      CustomClassAttributeName,
                                                      nullptr,
                                                      TraversalDirection::Up);
          
          if(Parent != nullptr) {
            
            // Again, try to extract CustomClass and CustomModule
            extractCustomClassAndModule(Parent, CustomClass, CustomModule);
          }
        }
        
        // Check if should rename and if yes then perform actual renaming
        if(!CustomClass.empty()) {
          
          std::string PropertyName = std::string(
                                     reinterpret_cast<const char *>(xmlGetProp(
                                                 Node,
                                                 OutletPropertyAttributeName)));
          
          auto SymbolIterator = RenamedSymbols.find(PropertyName);
          
          if ( SymbolIterator != RenamedSymbols.end() ) {
            
            auto Symbol = SymbolIterator->second;
            
            if(shouldRename(Symbol, CustomClass, CustomModule)) {
              xmlSetProp(Node,
                         OutletPropertyAttributeName,
                         reinterpret_cast<const xmlChar *>
                                               (Symbol.ObfuscatedName.c_str()));
              
              PerformedRenaming = true;
            }
          }
        }
      }
    }
  }
};
  
LayoutRenamer::LayoutRenamer(std::string FileName) {
  this->FileName = FileName;
  XmlDocument = xmlReadFile(FileName.c_str(),
                            /* encoding */ "UTF-8",
                            /* options */ 0);
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
llvm::Expected<std::unique_ptr<BaseLayoutRenamingStrategy>>
  LayoutRenamer::createRenamingStrategy(xmlNode *RootNode) {
    
  const auto *RootNodeName = reinterpret_cast<const xmlChar *>("document");
  
  if (xmlStrcmp(RootNode->name, RootNodeName) == 0) {
    
    const auto *
    RootNodeTypeAttributeName = reinterpret_cast<const xmlChar *>("type");
    
    const auto *
    RootNodeVersionAttributeName = reinterpret_cast<const xmlChar *>("version");
    
    const auto *
    TargetRuntimeAttributeName = reinterpret_cast<const xmlChar *>
                                                              ("targetRuntime");
    
    auto TypeAttributeValue = std::string(
                              reinterpret_cast<const char *>(xmlGetProp(
                                                   RootNode,
                                                   RootNodeTypeAttributeName)));
    
    auto VersionAttributeValue = std::string(
                                 reinterpret_cast<const char *>(xmlGetProp(
                                                RootNode,
                                                RootNodeVersionAttributeName)));

    std::set<std::string> SupportedDocumentTypes = {
      "com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB",
      "com.apple.InterfaceBuilder3.Cocoa.Storyboard.XIB",
      "com.apple.InterfaceBuilder3.CocoaTouch.XIB",
      "com.apple.InterfaceBuilder3.Cocoa.XIB"
    };
    
    if(SupportedDocumentTypes.find(TypeAttributeValue) !=
                                                    SupportedDocumentTypes.end()
       && VersionAttributeValue == "3.0") {
      
      // try to find out what the target platform is
      xmlChar* TargetRuntimeValue = xmlGetProp(RootNode,
                                               TargetRuntimeAttributeName);
      
      TargetRuntime TargetRuntime = Undefined;
      if(TargetRuntimeValue != nullptr) {
        std::string TargetRuntimeValueStr = std::string(
                                            reinterpret_cast<const char *>(
                                                           TargetRuntimeValue));
        
        if (TargetRuntimeValueStr.find("CocoaTouch") != std::string::npos) {
          TargetRuntime = CocoaTouch;
        } else if (TargetRuntimeValueStr.find("Cocoa") != std::string::npos) {
          TargetRuntime = Cocoa;
        }
      }
      
      if(TargetRuntime == Undefined) {
        return stringError("Could not parse target runtime in: " + FileName);
      }
      
      return llvm::make_unique<XCode9RenamingStrategy>(RootNode, TargetRuntime);
    } else {

      // Probably a new version of layout file came out
      // and it should be handled separately.
      // Create a new BaseLayoutRenamingStrategy implementation
      // and update this method so it returns correct Strategy for specific
      // version of the layout file.
      return stringError("Unknown layout file version for layout: " + FileName);
    }
  } else {
     return stringError("Unknown root node type in layout file: " + FileName);
  }
}

llvm::Expected<bool>
  LayoutRenamer::performRenaming(
                 std::unordered_map<std::string, SymbolRenaming> RenamedSymbols,
                 std::string OutputPath) {

  if (XmlDocument == nullptr) {
    return stringError("Could not parse file: " + FileName);
  }
  
  xmlNode *RootNode = xmlDocGetRootElement(XmlDocument);
  
  auto RenamingStrategyOrError = createRenamingStrategy(RootNode);
  
  if (auto Error = RenamingStrategyOrError.takeError()) {
    return std::move(Error);
  }
  
  auto RenamingStrategy = std::move(RenamingStrategyOrError.get());
  
  bool PerformedRenaming = false;
  RenamingStrategy->performActualRenaming(RootNode,
                                          RenamedSymbols,
                                          PerformedRenaming);
  
  xmlSaveFileEnc(static_cast<const char *>(OutputPath.c_str()),
                 XmlDocument,
                 reinterpret_cast<const char *>(XmlDocument->encoding));
  
  return PerformedRenaming;
}
        
} //namespace obfuscation
} //namespace swift
