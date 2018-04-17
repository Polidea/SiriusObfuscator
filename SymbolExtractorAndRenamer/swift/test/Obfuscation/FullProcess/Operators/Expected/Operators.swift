prefix operator O1_---
infix operator O1_^^^
postfix operator O1_+++

extension Double {
  static prefix func O1_--- (SP1_number: Double) -> Double { return SP1_number - 2 }
  static func O1_^^^ (SP1_left: Double, SP1_right: Double) -> Double { return pow(SP1_left, SP1_right) + SP1_left }
  static postfix func O1_+++ (SP2_number: Double) -> Double { return SP2_number + 2 }
}

O1_---44
6O1_^^^2
40O1_+++
