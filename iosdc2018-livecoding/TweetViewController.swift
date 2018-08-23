/*
 User stories:

 * [ ] 140文字まで文字を書くことができ、今の残り文字数が分かる
 * [ ] 文字数が1~140の時のみ投稿できることが分かる
 * [ ] 現在入力されているテキストを投稿できる
 * [ ] 投稿を開始してから完了するまで投稿中であることが分かる
 * [ ] 投稿が正常に完了したことが分かる
 * [ ] 2回連続で同じ内容の投稿した時にエラーになり、そのエラー内容が分かる

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

    private func showCompletedAlert() {
        let alert = UIAlertController(
            title: "Tweet successfully",
            message: nil,
            preferredStyle: .alert
        ).then {
            $0.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }

    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        ).then {
            $0.addAction(UIAlertAction(title: "OK", style: .default))
        }
        present(alert, animated: true)
    }
}
