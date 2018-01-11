add_swift_library(swiftObfuscation STATIC
  DataStructures.cpp
  FileIO.cpp
  NameMapping.cpp
  Random.cpp
  SymbolExtracting.cpp
  Renaming.cpp
  SymbolProvider.cpp
  CompilerInfrastructure.cpp
  Utils.cpp
  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
  swiftDriver
  swiftFrontend
)

