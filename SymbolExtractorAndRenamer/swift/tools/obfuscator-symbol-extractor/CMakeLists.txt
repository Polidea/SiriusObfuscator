add_swift_host_tool(obfuscator-symbol-extractor
  obfuscator-symbol-extractor.cpp
  LINK_LIBRARIES 
  swiftObfuscation
  LLVM_COMPONENT_DEPENDS
  Support
  SWIFT_COMPONENT 
  tools
)

