// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPTarget<SomeAnalytics: Analytics, SomeDevTools: DevTools>: Target {
    public let isProduction: Bool
    public let serverConfig: HIPServerConfig
    public let deeplinkConfig: HIPDeeplinkConfig
    public let analytics: SomeAnalytics
    public let devTools: SomeDevTools

    public init() {
        isProduction = true
        serverConfig = nil
        deeplinkConfig = nil
        analytics = nil
        devTools = nil
    }

    /// <mark> Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isProduction = try container.decodeIfPresent(Bool.self, forKey: .isProduction) ?? true
        serverConfig = try container.decodeIfPresent(HIPServerConfig.self, forKey: .serverConfig) ?? nil
        deeplinkConfig = try container.decodeIfPresent(HIPDeeplinkConfig.self, forKey: .deeplinkConfig) ?? nil
        analytics = try container.decodeIfPresent(SomeAnalytics.self, forKey: .analytics) ?? nil
        devTools = try container.decodeIfPresent(SomeDevTools.self, forKey: .devTools) ?? nil
    }
}

extension HIPTarget {
    public enum CodingKeys: String, CodingKey {
        case isProduction = "is_production"
        case serverConfig = "server_config"
        case deeplinkConfig = "deeplink_config"
        case analytics = "analytics"
        case devTools = "dev_tools"
    }
}

open class HIPServerConfig: ServerConfig {
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

extension HIPServerConfig {
    public enum CodingKeys: String, CodingKey {
        case base = "base"
        case apiBase = "api_base"
    }
}

open class HIPDeeplinkConfig: DeeplinkConfig {
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

extension HIPDeeplinkConfig {
    public enum CodingKeys: String, CodingKey {
        case host = "host"
    }
}
