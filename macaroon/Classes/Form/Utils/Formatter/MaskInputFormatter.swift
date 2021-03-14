// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public struct MaskInputFormatter: TextInputFormatter {
    public let pattern: String
    public let symbol: Character
    public let placeholder: String?
    public let initialCaretOffset: Int?

    private let base: PlaceholderTextInputFormatter

    public init(
        pattern: String,
        symbol: Character = "#",
        placeholder: String? = nil,
        initialCaretOffset: Int? = nil
    ) {
        self.pattern = pattern
        self.symbol = symbol
        self.placeholder = placeholder
        self.initialCaretOffset = initialCaretOffset
        self.base = PlaceholderTextInputFormatter(textPattern: pattern, patternSymbol: symbol)
    }

    public func format(
        _ string: String?
    ) -> String? {
        return base.format(
            string
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
    ) -> Output {
        var value =
            base.formatInput(
                currentText: input,
                range: range,
                replacementString: string
            )

        if value.formattedText == pattern,
           let placeholder = placeholder {
            value = base.formatInput(
                currentText: value.formattedText,
                range: range,
                replacementString: placeholder
            )
        }

        return (
            value.formattedText,
            getPreferredCaretOffset(
                value.caretBeginOffset
            )
        )
    }
}
