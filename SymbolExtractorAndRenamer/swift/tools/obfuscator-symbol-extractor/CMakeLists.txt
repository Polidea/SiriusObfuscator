add_swift_host_tool(obfuscator-symbol-extractor
  obfuscator-symbol-extractor.cpp
  LINK_LIBRARIES swiftDriver swiftFrontend swiftIDE
  SWIFT_COMPONENT tools
)

