// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol DeeplinkParser {
    associatedtype Pattern: DeeplinkPattern
    associatedtype Destination

    var host: String { get }
    var matchers: [Pattern: NSRegularExpression] { get }

    func discover(url: URL) -> Destination?
}

//extension DeeplinkParser {
//    public func discover(url: URL) -> Destination? {
//        let urlComponents = DeeplinkURLComponents(url: url, deeplinkHost: host)
//
//    }
//}

extension DeeplinkParser {
    public func formMatchers() -> [Pattern: NSRegularExpression] {
        return Pattern.allCases.reduce(into: [:], { $0[$1] = try? NSRegularExpression(pattern: $1.rawValue, options: .caseInsensitive) })
    }
}

public protocol DeeplinkPattern: Hashable, RawRepresentable, CaseIterable where RawValue == String { }

public struct DeeplinkURLComponents {
    public let subdomain: String
    public let path: String
    public let queryItems: [URLQueryItem]

    init(
        url: URL,
        deeplinkHost: String
    ) {
        guard let host = url.host.unwrapConditionally({ $0.hasSuffix(deeplinkHost) }) else {
            subdomain = ""
            path = ""
            queryItems = []
            return
        }
        if host == deeplinkHost {
            subdomain = ""
        } else {
            let hostComponents = deeplinkHost.components(separatedBy: ".")
            subdomain = hostComponents.first.unwrap(or: "")
        }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        path = urlComponents.unwrap(either: \.path, or: "")
        queryItems = urlComponents.unwrap(either: \.queryItems, or: [])
    }
}
