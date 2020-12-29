// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPAppTarget<ServerConfig: Decodable, DeeplinkConfig: Decodable>: AppTarget {
    public var isDevelopment: Bool
    public var serverConfig: ServerConfig
    public var deeplinkConfig: DeeplinkConfig

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
