// RUN: %target-prepare-obfuscation-for-file "Operators" %target-run-full-obfuscation

prefix operator ---
infix operator ^^^
postfix operator +++

extension Double {
  static prefix func --- (number: Double) -> Double { return number - 2 }
  static func ^^^ (left: Double, right: Double) -> Double { return pow(left, right) + left }
  static postfix func +++ (number: Double) -> Double { return number + 2 }
}

---44
6^^^2
40+++

