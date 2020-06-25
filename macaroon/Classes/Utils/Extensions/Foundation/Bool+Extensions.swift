// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Bool {
    public func `continue`(isTrue trueOperation: () -> Void, isFalse falseOperation: () -> Void) {
        self ? trueOperation() : falseOperation()
    }

    public func `return`<T>(isTrue trueTransform: () -> T, isFalse falseTransform: () -> T) -> T {
        return self ? trueTransform() : falseTransform()
    }
}
