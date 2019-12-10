// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class DeeplinkConfig: DeeplinkConfigConvertible {
    public let host: String

    /// <mark> Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        host = try container.decodeIfPresent(String.self, forKey: .host) ?? ""
    }

    /// <mark> ExpressibleByStringLiteral
    public required init(stringLiteral value: String) {
        host = value
    }

    /// <mark> ExpressibleByNilLiteral
    public required init(nilLiteral: ()) {
        host = ""
    }
}

extension DeeplinkConfig {
    public enum CodingKeys: String, CodingKey {
        case host = "host"
    }
}

public protocol DeeplinkConfigConvertible: AnyObject, Decodable, ExpressibleByStringLiteral, ExpressibleByNilLiteral {
    var host: String { get }
}
