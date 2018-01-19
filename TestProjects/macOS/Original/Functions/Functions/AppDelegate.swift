//
//  AppDelegate.swift
//  Functions
//
//  Created by Krzysztof Siejkowski on 19/01/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let vc = ViewController()
    
    vc.bar()
    
    vc.foo(number: 24)
    
    vc.foo()
    
    vc.foo(number: 42, text: "24")
    
    ViewController.baz()
    
    vc.viewDidLoad()
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

