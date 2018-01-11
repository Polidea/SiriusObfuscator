import UIKit

class CustomInitViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
