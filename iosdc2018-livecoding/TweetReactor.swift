import RxSwift
import ReactorKit

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
            return (1...TwitterService.MAX_TEXT_LENGTH).contains(text.count) && !tweeting
        }
        var numberOfTextCountRemains: Int {
            return TwitterService.MAX_TEXT_LENGTH - text.count
        }
    }

    let errorRelay = PublishSubject<Error>()
    let completedRelay = PublishSubject<Void>()

    private let twitterService = TwitterService()

    let initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateText(let text):
            return Observable.just(Mutation.setText(text))
        case .tweet:
            return Observable.concat([
                Observable.just(Mutation.setTweeting(true)),
                twitterService.tweet(text: currentState.text).asObservable()
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
