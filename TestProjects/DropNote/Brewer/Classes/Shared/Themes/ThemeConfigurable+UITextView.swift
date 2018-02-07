//
//  ThemeConfigurable+UITextView.swift
//  Brewer
//
//  Created by Maciej Oczko on 08.05.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension ThemeConfigurable where Self: UITextView {
    func configureWithTheme(_ theme: ThemeConfiguration?) {
        guard let theme = theme else { return }
        backgroundColor = theme.lightColor
        font = theme.defaultFontWithSize(font?.pointSize ?? 0)
        textColor = theme.darkColor
    }
}
