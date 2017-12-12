add_swift_host_tool(obfuscator-renamer
  obfuscator-renamer.cpp
  LINK_LIBRARIES swiftDriver swiftFrontend swiftIDE
  SWIFT_COMPONENT tools
)

