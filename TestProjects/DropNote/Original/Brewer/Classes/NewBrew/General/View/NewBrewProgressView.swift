//
//  NewBrewProgressView.swift
//  Brewer
//
//  Created by Maciej Oczko on 22.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class NewBrewProgressView: UIStackView {
    fileprivate var selectedIconColor = UIColor.white
    
    @IBOutlet weak var backgroundView: UIView!
    
    func selectIconAtIndex(_ index: Int) {
        guard arrangedSubviews.count > index else { return }
        guard index >= 0 else { return }
        for (idx, view) in arrangedSubviews.enumerated() {
            if idx != index {
                view.tintColor = tintColor
            } else {
                view.tintColor = selectedIconColor
            }
        }
    }
    
    func configureWithIcons(_ icons: [Asset]) {
        subviews.forEach { $0.removeFromSuperview() }
        for icon in icons {
            let iconImage = UIImage(asset: icon)?.withRenderingMode(.alwaysTemplate)
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = tintColor
            addArrangedSubview(iconImageView)
        }
    }
    
    func show(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 1
            self.backgroundView.alpha = 1
        }) 
    }
    
    func hide(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.alpha = 0
            self.backgroundView.alpha = 0
        }) 
    }
    
    func enable(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.arrangedSubviews.forEach(self.enableIconView)
        }) 
    }
    
    func disable(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
            self.arrangedSubviews.forEach(self.disableIconView)
        }) 
    }
    
    fileprivate func enableIconView(_ view: UIView) {
        if view.tintColor == UIColor.lightGray {
            view.tintColor = tintColor
        }        
    }
    
    fileprivate func disableIconView(_ view: UIView) {
        view.tintColor = UIColor.lightGray
    }
}

extension NewBrewProgressView {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundView.backgroundColor = theme.lightColor
        tintColor = UIColor.lightGray
        selectedIconColor = theme.darkTintColor
    }
}
