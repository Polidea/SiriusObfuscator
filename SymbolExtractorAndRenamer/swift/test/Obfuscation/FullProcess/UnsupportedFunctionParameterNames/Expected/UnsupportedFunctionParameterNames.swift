
class T1_SampleClass {}

func NF1_`backticksName`(EP1_`backticksExtName` IP1_`backTicksIntName`: T1_SampleClass) {}

// overriding functions
class T1_Base {
  subscript(SP1_index: Int) -> String { return "" }
  subscript(_ IP1_indexInt: Int) -> String { return "" }
  subscript(EP1_indexExt IP2_indexInt: Int) -> String { return "" }
}

class T1_Derived: T1_Base { 
  override subscript(index: Int) -> String { return "" }
  override subscript(_ IP3_indexInt: Int) -> String { return "" }
  override subscript(indexExt IP4_indexInt: Int) -> String { return "" }
}

//protocol functions - internal parameter names in protocol function's definition and implementation should be different
protocol T1_ProtocolFunc {
  func NF1_pFunc2(_ IP1_pFunc: Int)
  func NF1_pFunc3(EP1_extpFunc IP1_intpFunc: Int)
  func NF1_pFunc4(SP1_singleFunc: Int)
}

class T1_ProtocolFunClass: T1_ProtocolFunc {
  func NF1_pFunc2(_ IP2_pFunc: Int) {}
  func NF1_pFunc3(EP1_extpFunc IP2_intpFunc: Int) {}
  func NF1_pFunc4(EP1_singleFunc IP1_singleIntFunc: Int) {}
}
