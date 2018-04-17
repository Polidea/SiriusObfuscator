//
//  ViewController.swift
//  CarthageExample
//
//  Created by Jerzy Kleszcz on 09/04/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  lazy var box = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(box)
    box.snp.makeConstraints { (make) -> Void in
      make.width.height.equalTo(50)
      make.center.equalTo(self.view)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

