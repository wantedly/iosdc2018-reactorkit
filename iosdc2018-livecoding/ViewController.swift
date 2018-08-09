/*
User stories:

- [x] Able to enter texts up to 140 chars
- [x] Able to post
- [x] Able to know what is a number of rest chars we can write
- [x] Able to know we can post by disabled post button
- [x] Able to know we are posting now
- [x] Able to know tweeting is complete
- [x] Able to know the error of duplicated content to tweet
*/

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
