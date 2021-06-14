// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Sequence where Element: Hashable {
    public func elementsEqualWithoutOrder<T: Sequence>(
        _ other: T
    ) -> Bool where Element == T.Element {
        return Set(self).symmetricDifference(Set(other)).isEmpty
    }
}
