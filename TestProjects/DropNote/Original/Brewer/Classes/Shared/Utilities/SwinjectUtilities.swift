//
// Created by Maciej Oczko on 07.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

extension Resolver {

    func viewControllerForIdentifier<T>(_ identifier: String) -> T where T: UIViewController {
        let sb = SwinjectStoryboard.create(name: identifier, bundle: nil, container: self)
        return sb.instantiateViewController(withIdentifier: identifier) as! T
    }
}
