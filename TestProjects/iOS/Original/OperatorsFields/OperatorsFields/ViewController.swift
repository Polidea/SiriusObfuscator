//
//  ViewController.swift
//  OperatorsFields
//
//  Created by Krzysztof Siejkowski on 02/02/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import UIKit

struct Sample {
  var number: Int = 24
  var text: String = "24"
}

prefix operator ---
infix operator ^^^
postfix operator +++

extension Double {
  
  static prefix func --- (number: Double) -> Double {
    return number - 2
  }
  
  static func ^^^ (left: Double, right: Double) -> Double {
    return pow(left, right) + left
  }
  
  static postfix func +++ (number: Double) -> Double {
    return number + 2
  }

}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    var sample = Sample()
    sample.number = 42
    sample.text = "42"
    
    ---44
    6^^^2
    40+++
  }
  
  static func asd() {}
  
}

