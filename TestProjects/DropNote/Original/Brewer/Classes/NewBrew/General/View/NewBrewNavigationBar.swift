//
//  NewBrewNavigationBar.swift
//  Brewer
//
//  Created by Maciej Oczko on 14.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewNavigationBar: UIView {
    @IBOutlet weak var previousButton: UIButton! {
        didSet {
            previousButton.imageView?.contentMode = .center
            previousButton.imageView?.clipsToBounds = false
            previousButton.layer.cornerRadius = 22
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.imageView?.contentMode = .center
            nextButton.imageView?.clipsToBounds = false
            nextButton.layer.cornerRadius = 22
        }
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    func hide(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 0
        }) 
    }
    
    func show(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1
        }) 
    }
    
    func hideNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 0
        }) 
    }
    
    func showNextArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.nextButton.alpha = 1
        }) 
    }
    
    func hidePreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 0
        }) 
    }
    
    func showPreviousArrow(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.previousButton.alpha = 1
        }) 
    }
}

extension NewBrewNavigationBar {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        backgroundColor = UIColor.clear
        nextButton.backgroundColor = theme?.lightColor
        nextButton.layer.borderColor = theme?.lightTintColor.cgColor
        nextButton.layer.borderWidth = 0.5
        previousButton.backgroundColor = theme?.lightColor
        previousButton.layer.borderColor = theme?.lightTintColor.cgColor
        previousButton.layer.borderWidth = 0.5
    }
}
