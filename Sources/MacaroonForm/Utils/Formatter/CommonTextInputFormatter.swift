// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public struct CommonTextInputFormatter: TextPatternInputFormatter {
    public let pattern: String
    public let symbol: Character
    public let placeholder: String?
    public let preformatter: ((String?) -> String?)?

    private let base: DefaultTextInputFormatter

    public init(
        pattern: String,
        placeholder: String? = nil,
        preformatter: ((String?) -> String?)? = nil
    ) {
        self.pattern = pattern
        self.symbol = "#"
        self.placeholder = placeholder
        self.preformatter = preformatter
        self.base = DefaultTextInputFormatter(textPattern: pattern, patternSymbol: symbol)
    }

    public func preformat(
        _ string: String?
    ) -> String? {
        guard let preformatter = preformatter else {
            return string
        }

        return preformatter(string)
    }

    public func format(
        _ string: String?
    ) -> String? {
        return base.format(
            preformat(string)
        )
    }

    public func unformat(
        _ string: String?
    ) -> String? {
        return base.unformat(
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
                replacementString: preformat(string).someString
            )

        if value.formattedText.isEmpty,
           let placeholder = placeholder {
            value = base.formatInput(
                currentText: "",
                range: NSRange(location: 0, length: 0),
                replacementString: placeholder
            )
        }

        return (value.formattedText, value.caretBeginOffset)
    }
}
