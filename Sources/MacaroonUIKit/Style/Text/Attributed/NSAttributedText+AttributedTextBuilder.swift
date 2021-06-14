// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension NSAttributedString {
    public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let finalAttributedString = NSMutableAttributedString()
        finalAttributedString.append(lhs)
        finalAttributedString.append(rhs)
        return finalAttributedString
    }

    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        lhs = lhs + rhs
    }
}

extension Optional where Wrapped == NSAttributedString {
    public var isNilOrEmpty: Bool {
        return self?.string.isEmpty ?? true
    }
}
