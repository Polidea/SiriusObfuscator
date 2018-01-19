add_swift_library(swiftObfuscation STATIC
  CompilerInfrastructure.cpp
  DataStructures.cpp
  DeclarationParser.cpp
  FileIO.cpp
  NameMapping.cpp
  Renaming.cpp
  SourceFileWalker.cpp
  SymbolExtracting.cpp
  Utils.cpp
  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
  swiftDriver
  swiftFrontend
)

