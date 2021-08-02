// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

public struct FixedCharacterCountValidator: Validator {
    public typealias FailMessage = (Error) -> EditText?

    public let count: Int
    public let allowedCharacters: CharacterSet?
    public let failMessage: FailMessage?

    public init(
        _ count: Int,
        _ allowedCharacters: CharacterSet? = nil,
        _ failMessage: FailMessage? = nil
    ) {
        self.count = count
        self.allowedCharacters = allowedCharacters
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
            let text = text?.withoutWhitespaces(),
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

        if text.count < count {
            return .failure(Error.lesser)
        }

        if text.count > count {
            return .failure(Error.greater)
        }

        return .success
    }

    public func getMessage(
        for error: ValidationError
    ) -> EditText? {
        return failMessage?(error as! Error)
    }
}

extension FixedCharacterCountValidator {
    public enum Error: ValidationError {
        case required
        case nonAllowedCharacter
        case lesser
        case greater
    }
}
