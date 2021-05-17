// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public struct CommonTextInputFormatter: TextPatternInputFormatter {
    public let pattern: String
    public let symbol: Character
    public let placeholder: String?

    private let base: DefaultTextInputFormatter

    public init(
        pattern: String,
        placeholder: String? = nil
    ) {
        self.pattern = pattern
        self.symbol = "#"
        self.placeholder = placeholder
        self.base = DefaultTextInputFormatter(textPattern: pattern, patternSymbol: symbol)
    }

    public func format(
        _ string: String?
    ) -> String? {
        return base.format(
            string
        )
    }

//    public func format(_ unformattedText: String?) -> String? {
//        guard let unformattedText = unformattedText else { return nil }
//        var formatted = ""
//        var unformattedIndex = 0
//        var patternIndex = 0
//
//        while patternIndex < pattern.count && unformattedIndex < unformattedText.count {
//            guard let patternCharacter = pattern.characterAt(patternIndex) else { break }
//            if patternCharacter == symbol {
//                if let unformattedCharacter = unformattedText.characterAt(unformattedIndex) {
//                    formatted.append(unformattedCharacter)
//                }
//                unformattedIndex += 1
//            } else {
//                formatted.append(patternCharacter)
//            }
//            patternIndex += 1
//        }
//        return formatted
//    }

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
                replacementString: string
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
