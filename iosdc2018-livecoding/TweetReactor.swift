import ReactorKit
import RxSwift

class TweetReactor: Reactor {
    enum Action {
        case updateText(String)
        case submit
    }

    enum Mutation {
        case setText(String)
        case setSubmitting(Bool)
    }

    struct State {
        var text: String = ""
        var isSubmitting: Bool = false

        var remainingTextCount: Int {
            return TwitterService.MAX_TEXT_LENGTH - text.count
        }

        var isTweetButtonEnabled: Bool {
            return (1...TwitterService.MAX_TEXT_LENGTH).contains(text.count)
        }
    }

    let initialState = State()

    private let service = TwitterService()

    let completedRelay = PublishSubject<Void>()
    let errorRelay = PublishSubject<Error>()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateText(let text):
            return Observable.just(Mutation.setText(text))
        case .submit:
            return Observable.concat([
                Observable.just(Mutation.setSubmitting(true)),
                service.tweet(text: currentState.text)
                    .asObservable()
                    .do(onNext: { _ in self.completedRelay.onNext(()) })
                    .do(onError: { self.errorRelay.onNext($0) })
                    .flatMap { _ in Observable.empty() }
                    .catchError { _ in Observable.empty() },
                Observable.just(Mutation.setSubmitting(false)),
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setText(let text):
            state.text = text
        case .setSubmitting(let isSubmitting):
            state.isSubmitting = isSubmitting
        }
        return state
    }
}
