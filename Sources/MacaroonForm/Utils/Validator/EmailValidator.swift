// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

public struct EmailValidator: Validator {
    public typealias FailMessage = (Error) -> EditText?

    public let optional: Bool
    public let failMessage: FailMessage?

    public init(
        optional: Bool = false,
        failMessage: FailMessage?
    ) {
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

        let detector =
            try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(text.startIndex..<text.endIndex, in: text)

        guard
            let matches =
                detector?.matches(
                    in: text,
                    options: [.anchored],
                    range: range
                ),
            let match = matches.first,
            matches.count == 1
        else {
            return .failure(Error.invalid)
        }

        if match.url?.scheme != "mailto" {
            return .failure(Error.invalid)
        }

        return .success
    }

    public func getMessage(
        for error: ValidationError
    ) -> EditText? {
        return failMessage?(error as! Error)
    }
}

extension EmailValidator {
    public enum Error: ValidationError {
        case required
        case invalid
    }
}
