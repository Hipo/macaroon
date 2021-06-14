// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

public struct RequiredValidator: Validator {
    public let failureReason: String
    public let allowedCharacters: CharacterSet?

    public init(
        _ failureReason: String,
        _ allowedCharacters: CharacterSet? = nil
    ) {
        self.failureReason = failureReason
        self.allowedCharacters = allowedCharacters
    }

    public func validate(
        _ inputFieldView: FormInputFieldView
    ) -> Validation {
        switch inputFieldView {
        case let textInputFieldView as FormTextInputFieldView:
            return validate(
                textInputFieldView
            )
        default:
            return .failure(failureReason)
        }
    }
}

extension RequiredValidator {
    private func validate(
        _ textInputFieldView: FormTextInputFieldView
    ) -> Validation {
        guard
            let text = textInputFieldView.text,
            !text.isEmpty
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
