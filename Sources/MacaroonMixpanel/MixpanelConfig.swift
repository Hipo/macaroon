// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public struct MixpanelConfig: JSONModel {
    public let apiToken: String

    public enum CodingKeys:
        String,
        CodingKey {
        case apiToken = "api_token"
    }

    public init(
        apiToken: String
    ) {
        self.apiToken = apiToken
    }
}

extension MixpanelConfig {
    func validate() -> Bool {
        return !apiToken.isEmpty
    }
}
