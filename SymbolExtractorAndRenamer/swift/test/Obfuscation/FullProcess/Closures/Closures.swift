//RUN: %target-prepare-obfuscation-for-file "Closures" %target-run-full-obfuscation
import AppKit

class Class {}

class ClosureTest {
  var prop = 1
  var prop2 = Class()
  
  var closureParam: (Int) -> Int = { param in
    return param
  }

  var closureShorthandParams: (Int, Int) -> String = {
    return "\($0) \($1)"
  }
  
  lazy var closureWeakSelf: () -> Int = { [weak self] in
    return self!.prop
  }
  
  lazy var closureUnownedSelf: () -> Int = { [unowned self] in
    return self.prop
  }
  
  lazy var closureUnownedSelfWeakProp: () -> Class = { [unowned self, weak p = self.prop2] in
    return p!
  }
  
  lazy var closureWeakSelfAndParam: (Int) -> Int = { [weak self] param in
    return self!.prop + param
  }
  
  lazy var closureUnownedSelfAndParam: (Int) -> Int = { [unowned self] param in
    return self.prop + param
  }
  
  func f0() -> Int {
    let local = 2
    
    self.closureWeakSelf()
    
    let closureCapturingLocalVariable: () -> Int = {
      return local
    }
    
    return closureCapturingLocalVariable()
  }
  
  func f1(closure: (Int) -> (Int)) -> Int {
    return closure(1)
  }
  
  func f2() {
    self.closureParam(1)
    self.closureShorthandParams(1, 2)
    self.closureWeakSelf()
    self.closureUnownedSelf()
    self.closureUnownedSelfWeakProp()
    self.closureWeakSelfAndParam(1)
    self.closureUnownedSelfAndParam(1)
    self.f1 { param in
      return param
    }
    self.f1 { [weak self] param in
      return param + self!.prop
    }
    self.f1 { [unowned self] param in
      return param + self.prop
    }
  }
}
