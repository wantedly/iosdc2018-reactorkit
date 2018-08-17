import RxSwift

enum TweetError: LocalizedError {
    case duplicated
    var errorDescription: String? {
        switch self {
        case .duplicated:
            return "Your tweet is duplicated with the last one."
        }
    }
}

class TwitterService {
    static let MAX_TEXT_LENGTH = 140

    private let scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "tweet")

    private var lastTweetedText: String? = nil

    func tweet(text: String) -> Single<Bool> {
        if lastTweetedText == text {
            return Single.just(false)
                .delay(1, scheduler: scheduler)
                .flatMap { _ in Single.error(TweetError.duplicated) }
                .do(onError: { _ in NSLog("Error: \(text)") })
        }
        lastTweetedText = text
        return Single.just(true)
            .delay(1, scheduler: scheduler)
            .do(onSuccess: { _ in NSLog("Succeeded: \(text)") })
    }
}
