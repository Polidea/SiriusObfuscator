//
//  AboutViewThanksCell.swift
//  Brewer
//
//  Created by Maciej Oczko on 29.07.2016.
//  Copyright © 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

final class AboutViewThanksCell: UITableViewCell {
    @IBOutlet weak var thanksTitleLabel: UILabel! {
        didSet {
            thanksTitleLabel.text = tr(.settingsAboutThanksForTransaltion) + ":"
        }
    }
}
