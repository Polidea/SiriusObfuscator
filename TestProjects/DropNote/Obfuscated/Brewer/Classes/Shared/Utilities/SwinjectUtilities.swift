//
// Created by Maciej Oczko on 07.02.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

extension Resolver {

    func viewControllerForIdentifier<T>(_ vz3dX7h5gdUh5WVegGIutVIVR7QL_e_i: String) -> T where T: UIViewController {
        let sb = SwinjectStoryboard.create(name: vz3dX7h5gdUh5WVegGIutVIVR7QL_e_i, bundle: nil, container: self)
        return sb.instantiateViewController(withIdentifier: vz3dX7h5gdUh5WVegGIutVIVR7QL_e_i) as! T
    }
}
