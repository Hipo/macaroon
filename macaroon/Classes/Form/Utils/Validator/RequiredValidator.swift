// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct RequiredValidator: Validator {
    public let failureReason: String

    public init(
        _ failureReason: String
    ) {
        self.failureReason = failureReason
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
        if let text = textInputFieldView.text,
           !text.isEmpty {
            return .success
        }

        return .failure(failureReason)
    }
}
