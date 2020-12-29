// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPServerConfig: Decodable {
    public var apiBase: String
    public var webBase: String

    public init(
        apiBase: String,
        webBase: String
    ) {
        self.apiBase = apiBase
        self.webBase = webBase
    }
}
