// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension Bool {
    public func `continue`(isTrue trueOperation: () -> Void, isFalse falseOperation: () -> Void) {
        self ? trueOperation() : falseOperation()
    }
}
