// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct DeeplinkURLComponents {
    public let subdomain: String
    public let path: String
    public let queryItems: [URLQueryItem]

    init(
        url: URL,
        deeplinkHost: String
    ) {
        guard let host = url.host.unwrapConditionally(where: { $0.hasSuffix(deeplinkHost) }) else {
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
        queryItems = urlComponents.unwrap(\.queryItems, or: [])
    }
}
