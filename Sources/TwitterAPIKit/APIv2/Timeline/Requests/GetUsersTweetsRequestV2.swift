import Foundation

/// https://developer.twitter.com/en/docs/twitter-api/tweets/timelines/api-reference/get-users-id-tweets
open class GetUsersTweetsRequestV2: TwitterAPIRequest {

    public enum Exclude: String {
        case retweets
        case replies
        func bind(param: inout [String: Any]) {
            param["exclude"] = rawValue
        }
    }

    public let id: String
    public let endTime: Date?
    public let exclude: Exclude?
    public let expansions: Set<TwitterTweetExpansionsV2>?
    public let maxResults: Int?
    public let mediaFields: Set<TwitterMediaFieldsV2>?
    public let paginationToken: String?
    public let placeFields: Set<TwitterPlaceFieldsV2>?
    public let pollFields: Set<TwitterPollFieldsV2>?
    public let sinceID: String?
    public let startTime: Date?
    public let tweetFields: Set<TwitterTweetFieldsV2>?
    public let untilID: String?
    public let userFields: Set<TwitterUserFieldsV2>?

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return "/2/users/\(id)/tweets"
    }

    open var parameters: [String: Any] {
        var p = [String: Any]()
        endTime?.bind(param: &p, for: "end_time")
        exclude?.bind(param: &p)
        expansions?.bind(param: &p)
        maxResults.map { p["max_results"] = $0 }
        mediaFields?.bind(param: &p)
        paginationToken.map { p["pagination_token"] = $0 }
        placeFields?.bind(param: &p)
        pollFields?.bind(param: &p)
        sinceID.map { p["since_id"] = $0 }
        startTime?.bind(param: &p, for: "start_time")
        tweetFields?.bind(param: &p)
        untilID.map { p["until_id"] = $0 }
        userFields?.bind(param: &p)
        return p
    }

    public init(
        id: String,
        endTime: Date? = .none,
        exclude: Exclude? = .none,
        expansions: Set<TwitterTweetExpansionsV2>? = .none,
        maxResults: Int? = .none,
        mediaFields: Set<TwitterMediaFieldsV2>? = .none,
        paginationToken: String? = .none,
        placeFields: Set<TwitterPlaceFieldsV2>? = .none,
        pollFields: Set<TwitterPollFieldsV2>? = .none,
        sinceID: String? = .none,
        startTime: Date? = .none,
        tweetFields: Set<TwitterTweetFieldsV2>? = .none,
        untilID: String? = .none,
        userFields: Set<TwitterUserFieldsV2>? = .none
    ) {
        self.id = id
        self.endTime = endTime
        self.exclude = exclude
        self.expansions = expansions
        self.maxResults = maxResults
        self.mediaFields = mediaFields
        self.paginationToken = paginationToken
        self.placeFields = placeFields
        self.pollFields = pollFields
        self.sinceID = sinceID
        self.startTime = startTime
        self.tweetFields = tweetFields
        self.untilID = untilID
        self.userFields = userFields
    }
}
