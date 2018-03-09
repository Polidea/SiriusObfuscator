
protocol T1_SampleProtocol { }

class T1_`BackticksName` {}

class T1_`BackticksNameGeneric`<`BackticksGenericParam`> {
  class T1_`BackticksInsideBackticksGeneric`: T1_`BackticksNameGeneric`<T1_`BackticksNameGeneric`<T1_`BackticksName`>> {}
}

// enum associated values should be renamed

enum T1_EnumWithAssoc {
  case1(V1_assoc1: Int, V1_assoc2: String)
  case2(V2_assoc1: Int, V2_assoc2: String)
}

let _ = T1_EnumWithAssoc.case1(V1_assoc1: 0, V1_assoc2: "")
let _ = T1_EnumWithAssoc.case2(V2_assoc1: 0, V2_assoc2: "")
