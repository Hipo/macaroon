// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Tryouts

public class TryoutsHandler: Decodable {
    public let config: Config

    /// <mark> Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let appId = try container.decodeIfPresent(String.self, forKey: .appId) ?? ""
        let apiKey = try container.decodeIfPresent(String.self, forKey: .apiKey) ?? ""
        let developerSecret = try container.decodeIfPresent(String.self, forKey: .developerSecret) ?? ""
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
        if config.isValid {
            Tryouts.initialize(withAppIdentifier: config.appId, apiKey: config.apiKey, secret: config.developerSecret)
        }
    }
}

extension TryoutsHandler {
    public enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case apiKey = "api_key"
        case developerSecret = "developer_secret"
    }
}

extension TryoutsHandler {
    public struct Config {
        public let appId: String
        public let apiKey: String
        public let developerSecret: String

        var isValid: Bool {
            return
                !appId.isEmpty &&
                !apiKey.isEmpty &&
                !developerSecret.isEmpty
        }
    }
}
