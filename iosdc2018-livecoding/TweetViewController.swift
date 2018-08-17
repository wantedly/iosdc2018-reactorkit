/*
 User stories:

 - [ ] Able to enter texts up to 140 chars
 - [ ] Able to post
 - [ ] Able to know what is a number of rest chars we can write
 - [ ] Able to know we can post by disabled post button
 - [ ] Able to know we are posting now
 - [ ] Able to know tweeting is complete
 - [ ] Able to know the error of duplicated content to tweet
 */

import UIKit
import Then
import UITextView_Placeholder
import SnapKit

class TweetViewController: UIViewController {

    private let tweetButton = UIBarButtonItem(
        title: "Tweet",
        style: .done,
        target: nil,
        action: nil
    )
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let textView = UITextView().then {
        $0.placeholder = "いまどうしてる？"
    }
    private let remainsLabel = UILabel().then {
        $0.text = "残りN文字"
        $0.textAlignment = .right
    }
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = tweetButton
        navigationController?.navigationBar.backgroundColor = .white

        // Hierarchy
        view.addSubview(stackView.then {
            $0.addArrangedSubview(textView)
            $0.addArrangedSubview(remainsLabel)
        })
        view.addSubview(activityIndicator)

        // Constraints
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
