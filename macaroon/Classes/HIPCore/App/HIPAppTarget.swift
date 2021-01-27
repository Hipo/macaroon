// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPAppTarget<ServerConfig: Decodable, DeeplinkConfig: Decodable>: AppTarget {
    public let isDevelopment: Bool
    public let serverConfig: ServerConfig
    public let deeplinkConfig: DeeplinkConfig

    public let bundleIdentifier = getBundleIdentifier()
    public let displayName = getDisplayName()
    public let version = getVersion()

    public init(
        isDevelopment: Bool,
        serverConfig: ServerConfig,
        deeplinkConfig: DeeplinkConfig
    ) {
        self.isDevelopment = isDevelopment
        self.serverConfig = serverConfig
        self.deeplinkConfig = deeplinkConfig
    }
}

extension HIPAppTarget {
    private enum CodingKeys: String, CodingKey {
        case isDevelopment
        case serverConfig
        case deeplinkConfig
    }
}
