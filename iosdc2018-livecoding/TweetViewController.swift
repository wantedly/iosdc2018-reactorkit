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
import RxSwift
import RxCocoa
import ReactorKit
import Then
import UITextView_Placeholder
import SnapKit

class TweetViewController: UIViewController, View {
    private let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.done, target: nil, action: nil)
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let textView = UITextView().then {
        $0.placeholder = "いまどうしてる？"
    }
    private let remainsLabel = UILabel().then {
        $0.textAlignment = .right
    }
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = tweetButton
        navigationController?.navigationBar.backgroundColor = .white
        view.addSubview(stackView.then {
            $0.addArrangedSubview(textView)
            $0.addArrangedSubview(remainsLabel)
        })
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func bind(reactor: TweetReactor) {
        // Action
        tweetButton.rx.tap
            .map { Reactor.Action.tweet }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        textView.rx.text.orEmpty
            .map { Reactor.Action.updateText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state
            .map { $0.tweeting }
            .distinctUntilChanged()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.tweetButtonEnabled }
            .distinctUntilChanged()
            .bind(to: tweetButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state
            .map { "残り: \($0.numberOfTextCountRemains)文字" }
            .distinctUntilChanged()
            .bind(to: remainsLabel.rx.text)
            .disposed(by: disposeBag)

        // Relay
        reactor.completedRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: nil, message: "Tweet successfully", preferredStyle: .alert).then {
                    $0.addAction(UIAlertAction(title: "OK", style: .default))
                }
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.errorRelay
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: nil, message: $0.localizedDescription, preferredStyle: .alert).then {
                    $0.addAction(UIAlertAction(title: "OK", style: .default))
                }
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
