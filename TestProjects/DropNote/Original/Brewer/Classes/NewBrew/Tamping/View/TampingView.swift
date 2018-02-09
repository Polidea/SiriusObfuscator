//
//  TampingView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class TampingView: UIView {
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var strongLabel: UILabel!
    @IBOutlet weak var strongImageView: UIImageView!    
    @IBOutlet weak var slider: UISlider!    
    @IBOutlet weak var informativeLabel: InformativeLabel!
}

extension TampingView {
    
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        slider.configureWithTheme(theme)
        [lightLabel, strongLabel].forEach {
            $0!.configureWithTheme(theme)
        }
        informativeLabel.configureWithTheme(theme)
    }
}
