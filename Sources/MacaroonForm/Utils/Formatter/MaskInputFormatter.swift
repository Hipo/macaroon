// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public struct MaskInputFormatter: TextPatternInputFormatter {
    public let pattern: String
    public let symbol: Character
    public let placeholder: String?
    public let initialCaretOffset: Int?
    public let preformatter: ((String?) -> String?)?

    private let base: PlaceholderTextInputFormatter

    public init(
        pattern: String,
        symbol: Character = "#",
        placeholder: String? = nil,
        initialCaretOffset: Int? = nil,
        preformatter: ((String?) -> String?)? = nil
    ) {
        self.pattern = pattern
        self.symbol = symbol
        self.placeholder = placeholder
        self.initialCaretOffset = initialCaretOffset
        self.preformatter = preformatter
        self.base = PlaceholderTextInputFormatter(textPattern: pattern, patternSymbol: symbol)
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

        if value.formattedText == pattern {
            if let placeholder = placeholder {
                value =
                    base.formatInput(
                        currentText: value.formattedText,
                        range: range,
                        replacementString: placeholder
                    )
            } else {
                value = .zero
            }
        }

        return (
            value.formattedText,
            getPreferredCaretOffset(
                value.caretBeginOffset
            )
        )
    }
}
