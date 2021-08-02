// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

public struct PhoneNumberValidator: Validator {
    public typealias FailMessage = (Error) -> EditText?

    public let failMessage: FailMessage?

    public init(
        _ failMessage: FailMessage?
    ) {
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
            return .failure(Error.required)
        }

        if text.count > 9 {
            return .failure(Error.invalid)
        }

        let detector =
            try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
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

        if match.resultType != .phoneNumber {
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

extension PhoneNumberValidator {
    public enum Error: ValidationError {
        case required
        case invalid
    }
}
