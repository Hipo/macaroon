// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public enum EditText {
    case normal(String?, UIFont? = nil)
    case attributed(NSAttributedString)
}

extension EditText {
    public func boundingSize(multiline: Bool = true, fittingSize: CGSize = .greatestFiniteMagnitude) -> CGSize {
        switch self {
        case .normal(let text, let font):
            return text?.boundingSize(attributes: .font(font), multiline: multiline, fittingSize: fittingSize) ?? .zero
        case .attributed(let attributedText):
            return attributedText.boundingSize(multiline: multiline, fittingSize: fittingSize)
        }
    }
}

extension EditText: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .normal(value)
    }
}

extension EditText: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .normal(nil)
    }
}
