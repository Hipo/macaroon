// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct RegexValidator: Validator {
    public let regex: String
    public let failureReason: String

    public init(
        _ regex: String,
        _ failureReason: String = ""
    ) {
        self.regex = regex
        self.failureReason = failureReason
    }

    public func validate(
        _ inputFieldView: FormInputFieldView
    ) -> Validation {
        guard let textInputFieldView = inputFieldView as? FormTextInputFieldView else {
            return .failure(failureReason)
        }

        return validate(
            textInputFieldView.text
        )
    }

    public func validate(
        _ text: String?
    ) -> Validation {
        guard
            let text = text,
            !text.isEmpty
        else {
            return .failure(failureReason)
        }

        guard let regexExpr = try? NSRegularExpression(pattern: regex) else {
            return .success
        }

        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regexExpr.matches(in: text, options: [.anchored], range: range)

        switch matches.count {
        case 1: return .success
        default: return .failure(failureReason)
        }
    }
}
