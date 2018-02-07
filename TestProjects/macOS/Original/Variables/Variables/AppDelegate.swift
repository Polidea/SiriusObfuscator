//
//  AppDelegate.swift
//  Variables
//
//  Created by Jerzy Kleszcz on 26/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  func bar() {
    let cl = Class1()
    print(cl.property)
    print(Class1.property)
    cl.foo1()
    cl.foo2()
    
    print(globalVariable)
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
  
}

