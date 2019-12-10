// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Tryouts

public class TryoutsHandler: DevToolConvertible {
    public let config: Config

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let appId = try container.decode(String.self, forKey: .appId)
        let apiKey = try container.decode(String.self, forKey: .apiKey)
        let developerSecret = try container.decode(String.self, forKey: .developerSecret)
        config = Config(appId: appId, apiKey: apiKey, developerSecret: developerSecret)

        initialize()
    }

    /// <mark> ExpressibleByNilLiteral
    public required init(nilLiteral: ()) {
        config = Config(appId: "", apiKey: "", developerSecret: "")
    }
}

extension TryoutsHandler {
    private func initialize() {
        Tryouts.initialize(withAppIdentifier: config.appId, apiKey: config.apiKey, secret: config.developerSecret)
    }
}

extension TryoutsHandler {
    public struct Config {
        let appId: String
        let apiKey: String
        let developerSecret: String
    }
}

extension TryoutsHandler {
    public enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case apiKey = "api_key"
        case developerSecret = "developer_secret"
    }
}
