//
// Created by Maciej Oczko on 31.01.2016.
// Copyright (c) 2016 Maciej Oczko. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollViewPageMetricsType {
    func isFirstPageOfScrollView(_ scrollView: UIScrollView) -> Bool
    func isLastPageOfScrollView(_ scrollView: UIScrollView) -> Bool
    func currentPageIndexForScrollView(_ scrollView: UIScrollView) -> Int
}

final class ScrollViewPageMetrics: ScrollViewPageMetricsType {

    func isFirstPageOfScrollView(_ scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x < scrollView.frame.size.width
    }
    
    func isLastPageOfScrollView(_ scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)
    }

    func currentPageIndexForScrollView(_ scrollView: UIScrollView) -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }

}
