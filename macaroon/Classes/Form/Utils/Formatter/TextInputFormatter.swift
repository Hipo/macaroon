// Copyright © 2019 hipolabs. All rights reserved.

import AnyFormatKit
import Foundation

public typealias TextInputFormattedOutput = (text: String, caretOffset: Int)

public protocol TextPatternInputFormatter: TextInputFormatter {
    var pattern: String { get }
    var symbol: Character { get }
}

public protocol TextInputFormatter {
    /// <note>
    /// The value can be used to format a placeholder instead of an empty string. It should be
    /// an unformatted text.
    var placeholder: String? { get }
    /// <note>
    /// The value can be used to shift caret to a certain position when the associated text input
    /// view has an initial text for an empty input.
    var initialCaretOffset: Int? { get }

    /// <note>
    /// Unformatted => Formatted
    func format(_ string: String?) -> String?
    /// <note>
    /// Formatted => Unformatted
    func unformat(_ string: String?) -> String?

    func format(_ input: String, changingCharactersIn range: NSRange, replacementString string: String) -> TextInputFormattedOutput
}

extension TextInputFormatter {
    public var placeholder: String? {
        return nil
    }
    public var initialCaretOffset: Int? {
        return nil
    }
}

extension TextInputFormatter {
    public func format(
        _ inputFieldView: FormTextInputFieldView,
        changingCharactersIn range: NSRange,
        replacementString string: String
    ) -> TextInputFormattedOutput {
        return format(
            inputFieldView.text.nonNil,
            changingCharactersIn: range,
            replacementString: string
        )
    }
}

extension TextInputFormatter {
    func getPreferredCaretOffset(
        _ editingCaretOffset: Int
    ) -> Int {
        guard let initialCaretOffset = initialCaretOffset else {
            return editingCaretOffset
        }

        return max(
            initialCaretOffset,
            editingCaretOffset
        )
    }
}
