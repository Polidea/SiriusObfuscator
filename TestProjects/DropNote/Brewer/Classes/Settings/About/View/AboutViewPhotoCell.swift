//
// Created by Maciej Oczko on 27.07.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class AboutViewPhotoCell: UITableViewCell {
    @IBOutlet weak var authorsLabel: UILabel!

    func configureWithTheme(_ theme: ThemeConfiguration?) {
        super.configureWithTheme(theme)
        authorsLabel.configureWithTheme(theme)
    }
}
