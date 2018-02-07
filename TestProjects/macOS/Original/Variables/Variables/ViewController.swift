//
//  ViewController.swift
//  Variables
//
//  Created by Jerzy Kleszcz on 26/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

protocol Protocol {
  var property: Int { get }
}

class ViewController: NSViewController {
  override var representedObject: Any? {
    didSet {}
  }
}

class Class1: Protocol, CustomStringConvertible {
  
  static var property = 5
  
  var property = 5
  
  func foo1() {
    var localVariable = 5
  }
  
  func foo2() {
    var localVariable = 5
  }
  
  var description: String { return "description" }
}

class Class2 {
  
  var property = 5
  
  func foo1() {
    var localVariable = 5
  }
}

class Class3: Class1 {
  override var property: Int {
    didSet {}
  }
}

var globalVariable = 5

func globalFunction() {
  var localVariable = 5
}
