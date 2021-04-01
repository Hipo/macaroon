// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct FixedCharacterCountValidator: Validator {
    public let count: Int
    public let failureReason: String

    public init(
        _ count: Int,
        _ failureReason: String = ""
    ) {
        self.count = count
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
            text.count == count
        else {
            return .failure(failureReason)
        }

        return .success
    }
}
