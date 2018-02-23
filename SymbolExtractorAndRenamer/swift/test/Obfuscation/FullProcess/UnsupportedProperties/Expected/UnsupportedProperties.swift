// stored let and var properties with special names
struct T1_SpecialStruct {
  let V1_`let`: Int
  var V1_`get`: Int
  let V1_`var`: String
  var V1_`set`: String
  let V1_`return`: Double
}

// properties with generic parameters
class T1_SomeClass<GenericParam> {
  var V1_param: String = ""
}

class T1_GenericUsingClass {
  let V1_array: Array<Int> = []
  let V1_map: [String : Int] = {:}
}

class T1_PropertiesUsingClass {
  var V1_array: Array<Int> = []
  var V1_map: [String : Int] = {:}
  var V1_generic = T1_SomeClass<GenericParam>()

  func foo() -> T1_SomeClass {
    V1_array = [42]
    V1_map["42"] = V1_array[0]
    V1_generic.V1_param = V1_map["42"]!.toString()
    return V1_generic
  }
}
