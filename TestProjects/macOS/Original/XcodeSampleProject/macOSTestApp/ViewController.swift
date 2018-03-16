//
//  ViewController.swift
//  macOSTestApp
//
//  Created by Jerzy Kleszcz on 12/12/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Cocoa
import CoreData

class Coffee: NSManagedObject {}

extension Coffee {
  @NSManaged var name: String?
}

@objc protocol SelectableSearchModelItem {
  var name: String? { get set }
}

extension Coffee: SelectableSearchModelItem {}

func foo(ex inter: Coffee) -> Coffee? {
  return nil
}

class ViewController: NSViewController {

  @IBOutlet weak var btn: NSButtonCell!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    fatalError("Sample error")

    // Do any additional setup after loading the view.
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

