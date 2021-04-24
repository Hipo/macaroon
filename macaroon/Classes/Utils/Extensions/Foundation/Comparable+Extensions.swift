// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Comparable {
    /// <note>
    /// `bounds` is half-range,`lower..<upper`.
    public func isBetween(
        _ bounds: (lower: Self, upper: Self)
    ) -> Bool {
        let range = Range(uncheckedBounds: bounds)

        return
            range.contains(
                self
            )
    }
}
