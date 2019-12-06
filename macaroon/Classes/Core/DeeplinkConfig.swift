// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class DeeplinkConfig: DeeplinkConfigConvertible {
    public let host: String

    public required init(host: String) {
        self.host = host
    }
}

public protocol DeeplinkConfigConvertible: AnyObject, Decodable, ExpressibleByStringLiteral, ExpressibleByNilLiteral {
    var host: String { get }

    init(host: String)
}

extension DeeplinkConfigConvertible {
    /// <mark> Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeeplinkConfigKeys.self)
        let host = try container.decodeIfPresent(String.self, forKey: .host)
        self.init(host: host ?? "")
    }

    /// <mark> ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self.init(host: value)
    }

    /// <mark> ExpressibleByNilLiteral
    public init(nilLiteral: ()) {
        self.init(host: "")
    }
}

public enum DeeplinkConfigKeys: String, CodingKey {
    case host = "host"
}
