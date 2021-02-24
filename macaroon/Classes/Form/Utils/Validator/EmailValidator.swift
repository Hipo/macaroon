// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct EmailValidator: Validator {
    public let failureReason: String

    public init(
        _ failureReason: String = ""
    ) {
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
            return .failure(failureReason)
        }

        if match.url?.scheme != "mailto" {
            return .failure(failureReason)
        }

        return .success
    }
}
