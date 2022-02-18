import Foundation

extension Result where Success == TwitterAPISuccessReponse, Failure == TwitterAPIKitError {

    func serialize() -> Result<TwitterAPISerializedSuccessResponse, Failure> {
        return flatMap { success in
            do {
                let data = success.data
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                return .success((jsonObj, success.rateLimit, success.response))
            } catch let error {
                return .failure(
                    .responseSerializeFailed(
                        reason: .jsonSerializationFailed(
                            error: error,
                            data: success.data,
                            rateLimit: success.rateLimit
                        ))
                )
            }
        }
    }

    func decode<T>(_ type: T.Type, decodar: JSONDecoder = TwitterAPIKit.defaultJSONDecoder) -> Result<
        TwitterAPIDecodedSuccessResponse<T>, Failure
    > {
        return flatMap { success in

            let result: Result<T, Error> = .init {
                return try decodar.decode(type, from: success.data)
            }
            return result.map { data in
                return (data: data, rateLimit: success.rateLimit, response: success.response)
            }
            .mapError { error in
                return .responseSerializeFailed(
                    reason: .jsonDecodeFailed(
                        error: error,
                        data: success.data,
                        rateLimit: success.rateLimit
                    ))
            }
        }
    }

    /// for debug result
    public var prettyString: String {
        switch self {
        case .failure(let error):
            return "Failure => \(error.localizedDescription)"
        case .success(let resp):

            let str: String

            // make pretty
            if let json = try? JSONSerialization.jsonObject(with: resp.data, options: []),
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            {
                str = String(data: jsonData, encoding: .utf8) ?? ""
            } else {
                str = String(data: resp.data, encoding: .utf8) ?? "Invalid data"
            }

            let url = resp.response.url?.absoluteString ?? "NULL URL"
            return "Success => \(url)\n\(resp.rateLimit)\n\(str.unescapingUnicodeCharacters.unescapeSlash)"
        }
    }
}

extension Result where Success == TwitterAPISerializedSuccessResponse, Failure == TwitterAPIKitError {

    public var prettyString: String {
        switch self {
        case .failure(let error):
            return "Failure => \(error.localizedDescription)"
        case .success(let resp):
            let str: String

            // make pretty
            if let jsonData = try? JSONSerialization.data(withJSONObject: resp.data, options: .prettyPrinted) {
                str = String(data: jsonData, encoding: .utf8) ?? ""
            } else {
                str = String(describing: resp.data)
            }

            let url = resp.response.url?.absoluteString ?? "NULL URL"
            return "Success => \(url)\n\(resp.rateLimit)\n\(str.unescapingUnicodeCharacters.unescapeSlash)"
        }
    }
}

extension String {

    fileprivate var unescapeSlash: String {
        return replacingOccurrences(of: #"\/"#, with: #"/"#)
    }

    fileprivate var unescapingUnicodeCharacters: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, "Any-Hex/Java" as NSString, true)
        return mutableString as String
    }
}
