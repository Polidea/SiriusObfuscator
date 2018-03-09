//XFAIL: *

//RUN: %target-prepare-obfuscation-for-file "UnsupportedTypes" %target-run-full-obfuscation

protocol SampleProtocol { }

class `BackticksName` {}

class `BackticksNameGeneric`<`BackticksGenericParam`> {
  class `BackticksInsideBackticksGeneric`: `BackticksNameGeneric`<`BackticksNameGeneric`<`BackticksName`>> {}
}

// enum associated values should be renamed

enum EnumWithAssoc {
  case1(assoc1: Int, assoc2: String)
  case2(assoc1: Int, assoc2: String)
}

let _ = EnumWithAssoc.case1(assoc1: 0, assoc2: "")
let _ = EnumWithAssoc.case2(assoc1: 0, assoc2: "")