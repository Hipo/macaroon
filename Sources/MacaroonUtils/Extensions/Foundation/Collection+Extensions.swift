// Copyright © Hipolabs. All rights reserved.

import Foundation

extension BidirectionalCollection {
    public var firstIndex: Index? {
        return
            isEmpty
                ? nil
                : startIndex
    }

    public var lastIndex: Index? {
        return
            isEmpty
                ? nil
                : index(before: endIndex)
    }
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
