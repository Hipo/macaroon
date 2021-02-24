// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

open class HIPDeeplinkConfig: Decodable {
    public let host: String

    public init(host: String) {
        self.host = host
    }
}
