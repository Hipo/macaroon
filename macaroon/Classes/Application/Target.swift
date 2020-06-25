// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Target: AnyObject, Decodable {
    associatedtype SomeServerConfig: ServerConfig
    associatedtype SomeDeeplinkConfig: DeeplinkConfig
    associatedtype SomeAnalytics: Analytics
    associatedtype SomeDevTools: DevTools

    var isProduction: Bool { get }
    var serverConfig: SomeServerConfig { get }
    var deeplinkConfig: SomeDeeplinkConfig { get }
    var analytics: SomeAnalytics { get }
    var devTools: SomeDevTools { get }
}

extension Target {
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
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.uncached)
            return try decoder.decode(Self.self, from: data)
        } catch let err {
            mc_crash(.targetCorrupted(reason: err))
        }
    }
}

public protocol ServerConfig: AnyObject, Decodable, ExpressibleByNilLiteral {
    var base: String { get }
    var apiBase: String { get }
}

public protocol DeeplinkConfig: AnyObject, Decodable, ExpressibleByStringLiteral, ExpressibleByNilLiteral {
    var host: String { get }
}

public protocol Analytics: AnyObject, Decodable, ExpressibleByNilLiteral { }

public protocol DevTools: AnyObject, Decodable, ExpressibleByNilLiteral { }

public protocol DevTool: AnyObject, Decodable, ExpressibleByNilLiteral { }
