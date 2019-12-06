// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class ServerConfig: ServerConfigConvertible {
    public let base: String
    public let apiBase: String

    public required init(
        base: String,
        apiBase: String
    ) {
        self.base = base
        self.apiBase = apiBase
    }
}

public protocol ServerConfigConvertible: AnyObject, Decodable, ExpressibleByNilLiteral {
    var base: String { get }
    var apiBase: String { get }

    init(
        base: String,
        apiBase: String
    )
}

extension ServerConfigConvertible {
    /// <mark> Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ServerConfigKeys.self)
        let base = try container.decodeIfPresent(String.self, forKey: .base)
        let apiBase = try container.decodeIfPresent(String.self, forKey: .apiBase)
        self.init(
            base: base ?? "",
            apiBase: apiBase ?? ""
        )
    }

    /// <mark> ExpressibleByNilLiteral
    public init(nilLiteral: ()) {
        self.init(
            base: "",
            apiBase: ""
        )
    }
}

public enum ServerConfigKeys: String, CodingKey {
    case base = "base"
    case apiBase = "api_base"
}
