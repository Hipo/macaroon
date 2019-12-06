// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class AppTarget<SomeAnalytics: AnalyticsConvertible, SomeDevTools: DevToolsConvertible>: AppTargetConvertible {
    public let isStore: Bool
    public let serverConfig: ServerConfig
    public let deeplinkConfig: DeeplinkConfig
    public let analytics: SomeAnalytics
    public let devTools: SomeDevTools

    public required init(
        isStore: Bool,
        serverConfig: ServerConfig,
        deeplinkConfig: DeeplinkConfig,
        analytics: SomeAnalytics,
        devTools: SomeDevTools
    ) {
        self.isStore = isStore
        self.serverConfig = serverConfig
        self.deeplinkConfig = deeplinkConfig
        self.analytics = analytics
        self.devTools = devTools
    }
}

public protocol AppTargetConvertible: AnyObject, Decodable {
    associatedtype SomeServerConfig: ServerConfigConvertible
    associatedtype SomeDeeplinkConfig: DeeplinkConfigConvertible
    associatedtype SomeAnalytics: AnalyticsConvertible
    associatedtype SomeDevTools: DevToolsConvertible

    var isStore: Bool { get }
    var serverConfig: SomeServerConfig { get }
    var deeplinkConfig: SomeDeeplinkConfig { get }
    var analytics: SomeAnalytics { get }
    var devTools: SomeDevTools { get }

    init(
        isStore: Bool,
        serverConfig: SomeServerConfig,
        deeplinkConfig: SomeDeeplinkConfig,
        analytics: SomeAnalytics,
        devTools: SomeDevTools
    )
}

extension AppTargetConvertible {
    /// <mark> Decodable
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AppTargetKeys.self)
        let isStore = try container.decodeIfPresent(Bool.self, forKey: .isStore)
        let serverConfig = try container.decodeIfPresent(SomeServerConfig.self, forKey: .serverConfig)
        let deeplinkConfig = try container.decodeIfPresent(SomeDeeplinkConfig.self, forKey: .deeplinkConfig)
        let analytics = try container.decodeIfPresent(SomeAnalytics.self, forKey: .analytics)
        let devTools = try container.decodeIfPresent(SomeDevTools.self, forKey: .devTools)
        self.init(
            isStore: isStore ?? true,
            serverConfig: serverConfig ?? nil,
            deeplinkConfig: deeplinkConfig ?? nil,
            analytics: analytics ?? nil,
            devTools: devTools ?? nil
        )
    }
}

extension AppTargetConvertible {
    var deviceOS: DeviceOS {
        #if os(iOS)
        return .iOS
        #elseif os(watchOS)
        return .watchOS
        #else
        mc_crash(.unsupportedDeviceOS)
        #endif
    }

    var deviceFamily: DeviceFamily {
        #if os(iOS)
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .unspecified:
            return .iPhone
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            mc_crash(.unsupportedDeviceFamily)
        }
        #elseif os(watchOS)
        return .watch
        #else
        mc_crash(.unsupportedDeviceFamily)
        #endif
    }
}

extension AppTargetConvertible {
    /// <note>
    /// - Config file must be in JSON format.
    /// - Config file must be saved in the 'main' bundle.
    /// - It is highly recommended for each target to have its own config file.
    /// - It is highly recommended to use the default values (target_config.json) for config file and extension.
    public static func load(fromResource name: String = "target", withExtension ext: String = "json") -> Self {
        guard let resourceUrl = Bundle.main.url(forResource: name, withExtension: ext) else {
            mc_crash(.targetNotFound)
        }
        do {
            let data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.uncached)
            return try Self.decoded(data)
        } catch let err {
            mc_crash(.targetCorrupted(reason: err))
        }
    }
}

public enum DeviceOS {
    case iOS
    case watchOS
}

public enum DeviceFamily {
    case iPhone
    case iPad
    case watch
}

public enum AppTargetKeys: String, CodingKey {
    case isStore = "is_store"
    case serverConfig = "server_config"
    case deeplinkConfig = "deeplink_config"
    case analytics = "analytics"
    case devTools = "dev_tools"
}
