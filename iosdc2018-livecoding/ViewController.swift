import UIKit

class ViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            TweetViewController().then {
                $0.reactor = TweetReactor()
            }
        ]
    }
}
