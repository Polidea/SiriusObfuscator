import AppKit

class T1_Class {}

class T1_ClosureTest {
  var V1_prop = 1
  var V1_prop2 = T1_Class()
  
  var V1_closureParam: (Int) -> Int = { param in
    return param
  }

  var V1_closureShorthandParams: (Int, Int) -> String = {
    return "\($0) \($1)"
  }
  
  lazy var V1_closureWeakSelf: () -> Int = { [weak self] in
    return self!.V1_prop
  }
  
  lazy var V1_closureUnownedSelf: () -> Int = { [unowned self] in
    return self.V1_prop
  }
  
  lazy var V1_closureUnownedSelfWeakProp: () -> T1_Class = { [unowned self, weak p = self.V1_prop2] in
    return p!
  }
  
  lazy var V1_closureWeakSelfAndParam: (Int) -> Int = { [weak self] param in
    return self!.V1_prop + param
  }
  
  lazy var V1_closureUnownedSelfAndParam: (Int) -> Int = { [unowned self] param in
    return self.V1_prop + param
  }
  
  func NF1_f0() -> Int {
    let local = 2
    
    self.V1_closureWeakSelf()
    
    let closureCapturingLocalVariable: () -> Int = {
      return local
    }
    
    return closureCapturingLocalVariable()
  }
  
  func NF1_f1(SP1_closure: (Int) -> (Int)) -> Int {
    return SP1_closure(1)
  }
  
  func NF1_f2() {
    self.V1_closureParam(1)
    self.V1_closureShorthandParams(1, 2)
    self.V1_closureWeakSelf()
    self.V1_closureUnownedSelf()
    self.V1_closureUnownedSelfWeakProp()
    self.V1_closureWeakSelfAndParam(1)
    self.V1_closureUnownedSelfAndParam(1)
    self.NF1_f1 { param in
      return param
    }
    self.NF1_f1 { [weak self] param in
      return param + self!.V1_prop
    }
    self.NF1_f1 { [unowned self] param in
      return param + self.V1_prop
    }
  }
}
