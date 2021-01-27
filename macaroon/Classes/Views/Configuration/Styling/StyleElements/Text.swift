// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Text {
    var origin: EditText { get }
    var highlighted: EditText? { get }
    var selected: EditText? { get }
    var disabled: EditText? { get }
}

extension Text {
    public var highlighted: EditText? {
        return nil
    }
    public var selected: EditText? {
        return nil
    }
    public var disabled: EditText? {
        return nil
    }
}

extension String: Text {
    public var origin: EditText {
        return .string(self)
    }
}

extension NSAttributedString: Text {
    public var origin: EditText {
        return .attributedString(self)
    }
}

public struct TextSet: Text {
    public let origin: EditText
    public let highlighted: EditText?
    public let selected: EditText?
    public let disabled: EditText?

    public init(
        _ origin: EditText,
        highlighted: EditText? = nil,
        selected: EditText? = nil,
        disabled: EditText? = nil
    ) {
        self.origin = origin
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}

public enum TextOverflow {
    case singleLine(NSLineBreakMode = .byTruncatingTail) /// <note> Single line.
    case singleLineFitting /// <note> Single line by adjusting font size to fit.
    case multiline(Int, NSLineBreakMode = .byTruncatingTail) /// <note> Certain number of lines.
    case fitting /// <note> Bounding text.
}
