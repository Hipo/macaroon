// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

public struct RegexValidator: Validator {
    public typealias FailMessage = (Error) -> EditText?

    public let regex: String
    public let optional: Bool
    public let failMessage: FailMessage?

    public init(
        regex: String,
        optional: Bool = false,
        failMessage: FailMessage? = nil
    ) {
        self.regex = regex
        self.optional = optional
        self.failMessage = failMessage
    }

    public func validate(
        _ inputFieldView: FormInputFieldView
    ) -> Validation {
        guard let textInputFieldView = inputFieldView as? FormTextInputFieldView else {
            return .failure(Error.required)
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
            return optional
                ? .success
                : .failure(Error.required)
        }

        guard let regexExpr = try? NSRegularExpression(pattern: regex) else {
            return .success
        }

        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regexExpr.matches(in: text, options: [.anchored], range: range)

        switch matches.count {
        case 1: return .success
        default: return .failure(Error.invalid)
        }
    }

    public func getMessage(
        for error: ValidationError
    ) -> EditText? {
        return failMessage?(error as! Error)
    }
}

extension RegexValidator {
    public enum Error: ValidationError {
        case required
        case invalid
    }
}
