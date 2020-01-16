// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public enum EditText {
    case normal(String)
    case attributed(NSAttributedString)
}

extension EditText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .normal(value)
    }
}
