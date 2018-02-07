add_swift_library(swiftObfuscation STATIC
  CompilerInfrastructure.cpp
  DataStructures.cpp
  DeclarationParser.cpp
  OperatorParser.cpp
  DeclarationParsingUtils.cpp
  ExpressionParser.cpp
  FileIO.cpp
  FunctionDeclarationParser.cpp
  NameMapping.cpp
  NominalTypeDeclarationParser.cpp
  ParameterDeclarationParser.cpp
  Renaming.cpp
  SourceFileWalker.cpp
  SymbolExtracting.cpp
  Utils.cpp
  VariableDeclarationParser.cpp
  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
  swiftDriver
  swiftFrontend
)

