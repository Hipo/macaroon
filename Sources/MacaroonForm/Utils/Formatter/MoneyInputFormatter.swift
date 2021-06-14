// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public struct MoneyInputFormatter: NumberInputFormatter {
    public let placeholder: String?

    private lazy var decimalSeparator = Locale.current.decimalSeparator ?? ","

    private let base: SumTextInputFormatter

    public init(
        numberFormatter: NumberFormatter = .currency,
        placeholder: String? = nil
    ) {
        self.placeholder = placeholder
        self.base = SumTextInputFormatter(numberFormatter: numberFormatter)
    }

    public func format(
        _ unformattedString: String?
    ) -> String? {
        return
            base.format(
                unformattedString
            )
    }

    public func format(
        _ number: NSNumber?
    ) -> String? {
        return
            format(
                number?.stringValue
            )
    }

    public func unformat(
        _ formattedString: String?
    ) -> String? {
        return
            base.unformat(
                formattedString
            )
    }

    public func unformat(
        _ string: String?
    ) -> NSNumber? {
        return
            base.unformatNumber(
                string
            )
    }

    public func format(
        _ input: String,
        changingCharactersIn range: NSRange,
        replacementString string: String
    ) -> TextInputFormattedOutput {
        var value =
            base.formatInput(
                currentText: input,
                range: range,
                replacementString: string
            )

        if value.formattedText.isEmpty ||
           value.formattedText == base.suffix {
            if let placeholder = placeholder {
                value = base.formatInput(
                    currentText: "",
                    range: NSRange(location: 0, length: 0),
                    replacementString: placeholder
                )
            } else {
                value = .zero
            }
        }

        return (value.formattedText, value.caretBeginOffset)
    }
}
