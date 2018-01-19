//
//  ViewController.swift
//  Functions
//
//  Created by Krzysztof Siejkowski on 19/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

protocol SampleProtocol {
  
  func bar() -> Int
  
  func foo(number: Int)
  
}

class ViewController: NSViewController, SampleProtocol {
  
  func bar() -> Int { return 42 }
  
  func foo(number: Int) {}
  
  func foo() {}
  
  func foo(number: Int, text: String) {}
  
  static func baz() {}
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

