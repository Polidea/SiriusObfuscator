# Make libxml2 available for swiftObfuscation.
# We assume that it's present because it's bundled with Xcode.
include_directories(SYSTEM ${LIBXML2_INCLUDE_DIR})

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
  LayoutRenamer.cpp
  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
  swiftDriver
  swiftFrontend
  ${LIBXML2_LIBRARIES}
)
