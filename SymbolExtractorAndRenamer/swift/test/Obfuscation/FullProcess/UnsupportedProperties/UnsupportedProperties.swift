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

// properties with generic parameters
class SomeClass<GenericParam> {
  var param: String = ""
}

class GenericUsingClass {
  let array: Array<Int> = []
  let map: [String : Int] = {:}
}

class PropertiesUsingClass {
  var array: Array<Int> = []
  var map: [String : Int] = {:}
  var generic = SomeClass<GenericParam>()

  func foo() -> SomeClass {
    array = [42]
    map["42"] = array[0]
    generic.param = map["42"]!.toString()
  }
}
