add_swift_library(swiftObfuscation STATIC
  CompilerInfrastructure.cpp
  DataStructures.cpp
  DeclarationParser.cpp
  DeclarationParsingUtils.cpp
  ExpressionParser.cpp
  FileIO.cpp
  FunctionDeclarationParser.cpp
  NameMapping.cpp
  ParameterDeclarationParser.cpp
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

