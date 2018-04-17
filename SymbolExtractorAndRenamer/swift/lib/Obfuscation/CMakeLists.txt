# Make libxml2 available for swiftObfuscation.
# We assume that it's present because it's bundled with Xcode.
include_directories(SYSTEM ${LIBXML2_INCLUDE_DIR})

add_swift_library(swiftObfuscation STATIC
  Collector.cpp
  CompilerInfrastructure.cpp
  DataStructures.cpp
  Excluder.cpp
  Extractor.cpp
  FileIO.cpp
  GlobalCollectedSymbolsUpdater.cpp
  Includer.cpp
  LayoutRenamer.cpp
  NameMapping.cpp
  Processor.cpp
  Renaming.cpp
  SymbolExtracting.cpp
  SymbolGenerator.cpp
  SymbolsWalkerAndCollector.cpp
  Utils.cpp

  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
  swiftDriver
  swiftFrontend
  ${LIBXML2_LIBRARIES}
)
