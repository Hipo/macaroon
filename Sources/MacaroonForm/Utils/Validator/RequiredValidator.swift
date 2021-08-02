// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils

public struct RequiredValidator: Validator {
    public typealias FailMessage = (Error) -> EditText?

    public let allowedCharacters: CharacterSet?
    public let failMessage: FailMessage?

    public init(
        _ allowedCharacters: CharacterSet? = nil,
        _ failMessage: FailMessage? = nil
    ) {
        self.allowedCharacters = allowedCharacters
        self.failMessage = failMessage
    }

    public func validate(
        _ inputFieldView: FormInputFieldView
    ) -> Validation {
        switch inputFieldView {
        case let textInputFieldView as FormTextInputFieldView:
            return validate(
                textInputFieldView.text
            )
        case let toggleInputFieldView as FormToggleInputFieldView:
            return validate(toggleInputFieldView.isSelected)
        default:
            return .failure(Error.required)
        }
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

        if let allowedCharacters = allowedCharacters {
            let isAllowed =
                text.containsCharacters(
                    in: allowedCharacters
                )

            if !isAllowed {
                return .failure(Error.nonAllowedCharacter)
            }
        }

        return .success
    }

    public func validate(
        _ flag: Bool
    ) -> Validation {
        return flag ? .success : .failure(Error.required)
    }

    public func getMessage(
        for error: ValidationError
    ) -> EditText? {
        return failMessage?(error as! Error)
    }
}

extension RequiredValidator {
    public enum Error: ValidationError {
        case required
        case nonAllowedCharacter
    }
}
