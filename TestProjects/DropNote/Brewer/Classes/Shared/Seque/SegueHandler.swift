//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier else {
            fatalError("Segue identifier doesn't exist")
        }
        guard let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Unknown segue: \(segue))")
        }
        return segueIdentifier
    }

    func performSegue(_ segueIdentifier: SegueIdentifier) {
        self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
    }

    func performSegue(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        self.performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }

}
