//
//  AppDelegate.swift
//  Constructors
//
//  Created by Krzysztof Siejkowski on 19/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    let ss = SampleStruct()
    let ssei = SampleStruct.init()
    
    
    
    let swi = StructWithInit()
    let swiei = StructWithInit.init()
    
    
    
    let swmi = StructWithMemberwiseInit(property: 5)
    let swmiei = StructWithMemberwiseInit.init(property: 5)
    
    
    
    let sc = SampleClass()
    let scei = SampleClass.init()
    
    
    
    let cwi = ClassWithInit()
    let cwiei = ClassWithInit.init()
    
    
    
    let vc1 = ViewController()
    let vc1ei = ViewController.init()
    let vc2 = ViewController(nibName: nil, bundle: nil)
    let vc2ei = ViewController.init(nibName: nil, bundle: nil)
    
    
    
    let cvc = CustomInitViewController(number: 5)
    let cvcei = CustomInitViewController.init(number: 5)
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

