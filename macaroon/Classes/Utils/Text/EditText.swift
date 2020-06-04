// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public enum EditText {
    case normal(String?, UIFont? = nil)
    case attributed(NSAttributedString)
}

extension EditText {
    public var isEmpty: Bool {
        switch self {
        case .normal(let text, _):
            return text.nonNil.isEmpty
        case .attributed(let attributedText):
            return attributedText.string.isEmpty
        }
    }
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

extension EditText: Equatable {
    public static func == (lhs: EditText, rhs: EditText) -> Bool {
        switch (lhs, rhs) {
        case (.normal(let lString, _), .normal(let rString, _)):
            return lString == rString
        case (.normal(let string, _), .attributed(let attributedString)),
             (.attributed(let attributedString), .normal(let string, _)):
            return string == attributedString.string
        case (.attributed(let lAttributedString), .attributed(let rAttributedString)):
            return lAttributedString.string == rAttributedString.string
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
