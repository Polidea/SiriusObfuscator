//
//  ViewController.swift
//  Constructors
//
//  Created by Krzysztof Siejkowski on 19/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

class SampleClass {
  
}

class ClassWithInit {
  
  init() {
    
  }
}

struct SampleStruct {
  
}

struct StructWithInit {
  
  init() {
    
  }
}

struct StructWithMemberwiseInit {
  var property: Int
}

class CustomInitViewController: NSViewController {
  
  init(number: Int) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}



class ViewController: NSViewController {

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

