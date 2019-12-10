// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class ServerConfig: ServerConfigConvertible {
    public let base: String
    public let apiBase: String

    /// <mark> Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        base = try container.decodeIfPresent(String.self, forKey: .base) ?? ""
        apiBase = try container.decodeIfPresent(String.self, forKey: .apiBase) ?? ""
    }

    /// <mark> ExpressibleByNilLiteral
    public required init(nilLiteral: ()) {
        base = ""
        apiBase = ""
    }
}

extension ServerConfig {
    public enum CodingKeys: String, CodingKey {
        case base = "base"
        case apiBase = "api_base"
    }
}

public protocol ServerConfigConvertible: AnyObject, Decodable, ExpressibleByNilLiteral {
    var base: String { get }
    var apiBase: String { get }
}
