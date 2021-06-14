// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct FixedCharacterCountValidator: Validator {
    public let count: Int
    public let failureReason: String
    public let allowedCharacters: CharacterSet?

    public init(
        _ count: Int,
        _ failureReason: String = "",
        _ allowedCharacters: CharacterSet? = nil
    ) {
        self.count = count
        self.failureReason = failureReason
        self.allowedCharacters = allowedCharacters
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
            let text = text?.withoutWhitespaces(),
            text.count == count
        else {
            return .failure(failureReason)
        }

        if let allowedCharacters = allowedCharacters {
            let isAllowed =
                text.containsCharacters(
                    in: allowedCharacters
                )

            if !isAllowed {
                return .failure(failureReason)
            }
        }

        return .success
    }
}
