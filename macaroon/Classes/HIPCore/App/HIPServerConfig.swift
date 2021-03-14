// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPServerConfig: Decodable {
    public let apiBase: String
    public let webBase: String

    public init(
        apiBase: String,
        webBase: String
    ) {
        self.apiBase = apiBase
        self.webBase = webBase
    }
}
