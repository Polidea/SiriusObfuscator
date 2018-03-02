//
//  ViewController.swift
//  XIBandConstructorParameters
//
//  Created by Krzysztof Siejkowski on 09/02/2018.
//  Copyright © 2018 Polidea. All rights reserved.
//

import UIKit

class View: UIView {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    let topSubview = TopSubview(color: .blue, taste: 42)
    addSubview(topSubview)

    let views = ["topSubview": topSubview]
    let verticalConstraint = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-32-[topSubview(>=100)]", metrics: nil, views: views
    )
    let horizontalConstraint = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-32-[topSubview]-32-|", metrics: nil, views: views
    )
    NSLayoutConstraint.activate(horizontalConstraint + verticalConstraint)
  }
}

class TopSubview: UIView {

  let taste: Int
  
  init(color: UIColor, taste: Int) {
    self.taste = taste
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = color
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("Never use me in xibs ever")
  }
}

class BottomSubview: UIButton {

  @IBAction func onClick() {
    if backgroundColor == .red {
      backgroundColor = .green
    } else {
      backgroundColor = .red
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}

class ViewController: UIViewController {}

