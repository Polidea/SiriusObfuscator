//
// Created by Maciej Oczko on 30.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import Swinject

protocol ResolvableContainer {
    var resolver: Resolver? { get set }
}
