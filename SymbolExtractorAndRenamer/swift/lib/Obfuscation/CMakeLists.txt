add_swift_library(swiftObfuscation STATIC
  Obfuscation.cpp
  LINK_LIBRARIES
  swiftParse
  swiftAST
  swiftSema
)

