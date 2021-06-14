// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Data {
    public var utf8Description: String {
        return
            count > 0
                ? String(data: self, encoding: .utf8) ?? .unavailable
                : "<empty>"
    }
}
