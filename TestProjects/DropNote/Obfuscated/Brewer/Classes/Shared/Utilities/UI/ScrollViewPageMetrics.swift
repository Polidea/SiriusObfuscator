//
// Created by Maciej Oczko on 31.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol Ii9yEBOawkRoPJ6iE4tjRn8OYcZEhtBR {
    func fvOT0uxEgB5X8k_5WZFxScY5ZGOaViKo(_ J98Kbqn2ON3C3JFZg7Y1uEcYLfRf6iVh: UIScrollView) -> Bool
    func _Kplqus8XC6119vDKpNXItG6rJyhehLj(_ vTbvpc4HEpU8lMi8sf1EcemKvHeyT3cA: UIScrollView) -> Bool
    func rwb0Ynbw4qe7VBliiB_qNJ3lsexh1PLp(_ qjXq1lq5z2ItpipUVgy_n86Pzbv1C4Ez: UIScrollView) -> Int
}

final class Vzm8pBSD1UyPnbLue5mbL6ltHJ4IO3Tg: Ii9yEBOawkRoPJ6iE4tjRn8OYcZEhtBR {

    func fvOT0uxEgB5X8k_5WZFxScY5ZGOaViKo(_ J98Kbqn2ON3C3JFZg7Y1uEcYLfRf6iVh: UIScrollView) -> Bool {
        return J98Kbqn2ON3C3JFZg7Y1uEcYLfRf6iVh.contentOffset.x < J98Kbqn2ON3C3JFZg7Y1uEcYLfRf6iVh.frame.size.width
    }
    
    func _Kplqus8XC6119vDKpNXItG6rJyhehLj(_ vTbvpc4HEpU8lMi8sf1EcemKvHeyT3cA: UIScrollView) -> Bool {
        return vTbvpc4HEpU8lMi8sf1EcemKvHeyT3cA.contentOffset.x >= (vTbvpc4HEpU8lMi8sf1EcemKvHeyT3cA.contentSize.width - vTbvpc4HEpU8lMi8sf1EcemKvHeyT3cA.frame.size.width)
    }

    func rwb0Ynbw4qe7VBliiB_qNJ3lsexh1PLp(_ qjXq1lq5z2ItpipUVgy_n86Pzbv1C4Ez: UIScrollView) -> Int {
        return Int(qjXq1lq5z2ItpipUVgy_n86Pzbv1C4Ez.contentOffset.x / qjXq1lq5z2ItpipUVgy_n86Pzbv1C4Ez.frame.size.width)
    }

}
