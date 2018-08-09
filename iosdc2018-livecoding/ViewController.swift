import UIKit
import Then
import SnapKit
import UITextView_Placeholder
import ReactorKit
import RxSwift
import RxCocoa

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
            .map { $0.tweetButtonEnabled }
            .distinctUntilChanged()
            .bind(to: tweetButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state
            .map { "残り: \($0.numberOfTextCountRemains)文字" }
            .distinctUntilChanged()
            .bind(to: remainsLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

private let MAX_TEXT_LENGTH = 140

func tweet() -> Completable {
    return Completable.empty()
        .delay(1, scheduler: SerialDispatchQueueScheduler(internalSerialQueueName: "tweet"))
}

class TweetReactor: Reactor {
    enum Action {
        case updateText(String)
        case tweet
    }

    enum Mutation {
        case setText(String)
        case setTweeting(Bool)
    }

    struct State {
        var text: String = ""
        var tweeting: Bool = false

        var tweetButtonEnabled: Bool {
            return (1...MAX_TEXT_LENGTH).contains(text.count) && !tweeting
        }
        var numberOfTextCountRemains: Int {
            return MAX_TEXT_LENGTH - text.count
        }
    }

    let errorRelay = PublishSubject<Error>()
    let completedRelay = PublishSubject<Void>()

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateText(let text):
            return Observable.just(Mutation.setText(text))
        case .tweet:
            return Observable.concat([
                Observable.just(Mutation.setTweeting(true)),
                tweet()
                    .asObservable()
                    .map { _ in
                        self.completedRelay.onNext(())
                        return Mutation.setTweeting(false)
                    }
                    .catchError {
                        self.errorRelay.onNext($0)
                        return Observable.just(Mutation.setTweeting(false))
                    },
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setText(let text):
            state.text = text
        case .setTweeting(let tweeting):
            state.tweeting = tweeting
        }
        return state
    }
}
