add_swift_host_tool(obfuscator-name-mapper
  obfuscator-name-mapper.cpp
  LINK_LIBRARIES 
  swiftObfuscation
  LLVM_COMPONENT_DEPENDS
  Support
  SWIFT_COMPONENT 
  tools 
)

