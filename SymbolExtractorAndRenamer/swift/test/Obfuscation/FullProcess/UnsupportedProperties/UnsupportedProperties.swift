// XFAIL: *
//RUN: %target-prepare-obfuscation-for-file "UnsupportedProperties" %target-run-full-obfuscation

// stored let and var properties with special names
struct SpecialStruct {
  let `let`: Int
  var `get`: Int
  let `var`: String
  var `set`: String
  let `return`: Double
}
