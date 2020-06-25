// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <mark> Color
public struct ColorGroup {
    public let normal: UIColor
    public let highlighted: UIColor?
    public let selected: UIColor?
    public let disabled: UIColor?

    public init(
        normal: UIColor,
        highlighted: UIColor? = nil,
        selected: UIColor? = nil,
        disabled: UIColor? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}

/// <mark> Font
public struct FontGroup {
    public let normal: Font
    public let highlighted: Font?
    public let selected: Font?
    public let disabled: Font?

    public init(
        normal: Font,
        highlighted: Font? = nil,
        selected: Font? = nil,
        disabled: Font? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}

public struct Font {
    public typealias TextStyle = UIFont.TextStyle

    public var scaled: UIFont? {
        guard let normal = normal else {
            return nil
        }
        guard let textStyle = textStyle else {
            return normal
        }
        let metrics = UIFontMetrics(forTextStyle: textStyle)

        if let maxSize = size.max {
            return metrics.scaledFont(for: normal, maximumPointSize: maxSize)
        }
        return metrics.scaledFont(for: normal)
    }
    public var preferred: UIFont {
        if let textStyle = textStyle {
            return scaled ?? UIFont.preferredFont(forTextStyle: textStyle)
        }
        return normal ?? UIFont.systemFont(ofSize: size.normal)
    }

    public let name: String
    public let size: FontSize
    public let textStyle: TextStyle?
    public let adjustsFontForContentSizeCategory: Bool
    public let normal: UIFont?

    public init(
        _ name: String,
        _ size: FontSize,
        _ textStyle: TextStyle? = nil
    ) {
        self.name = name
        self.size = size
        self.textStyle = textStyle
        self.adjustsFontForContentSizeCategory = textStyle != nil
        self.normal = UIFont(name: name, size: size.normal)
    }

    public init(
        _ name: String,
        _ size: FontSize,
        _ textStyle: TextStyle,
        adjustsFontForContentSizeCategory: Bool
    ) {
        self.name = name
        self.size = size
        self.textStyle = textStyle
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.normal = UIFont(name: name, size: size.normal)
    }

    public init(
        _ font: UIFont?,
        _ textStyle: TextStyle? = nil
    ) {
        self.name = font?.fontName ?? ""
        self.size = .init(normal: font?.pointSize ?? 17.0)
        self.textStyle = textStyle
        self.adjustsFontForContentSizeCategory = textStyle != nil
        self.normal = font
    }

    public init(
        _ font: UIFont?,
        _ textStyle: TextStyle,
        adjustsFontForContentSizeCategory: Bool
    ) {
        self.name = font?.fontName ?? ""
        self.size = .init(normal: font?.pointSize ?? 17.0)
        self.textStyle = textStyle
        self.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory
        self.normal = font
    }

    static public func logAll() {
        UIFont.familyNames.forEach { family in
            UIFont.fontNames(forFamilyName: family).forEach { print($0) }
        }
    }
}

public struct FontSize {
    public let normal: CGFloat
    public let max: CGFloat?

    public init(
        normal: CGFloat,
        max: CGFloat? = nil
    ) {
        self.normal = normal
        self.max = max
    }
}

extension FontSize: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = FontSize(normal: CGFloat(value))
    }
}

/// <mark> Image
public struct ImageGroup {
    public let normal: UIImage
    public let highlighted: UIImage?
    public let selected: UIImage?
    public let disabled: UIImage?

    public init(
        normal: UIImage,
        highlighted: UIImage? = nil,
        selected: UIImage? = nil,
        disabled: UIImage? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}

/// <mark> Text
public struct TextGroup {
    public let normal: EditText?
    public let highlighted: EditText?
    public let selected: EditText?
    public let disabled: EditText?

    public init(
        normal: EditText?,
        highlighted: EditText? = nil,
        selected: EditText? = nil,
        disabled: EditText? = nil
    ) {
        self.normal = normal
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}

public enum TextOverflow {
    case truncated /// <note> single line by truncating tail
    case singleLine(NSLineBreakMode) /// <note> single line
    case singleLineFitting /// <note> single line by adjusting font size to fit
    case multiline(Int, NSLineBreakMode) /// <note> certain number of lines
    case multilineFitting(Int, NSLineBreakMode) /// <note> certain number of lines by adjusting font size to fit
    case fitting /// <note> contained text
}

/// <mark> Layer
public struct CornerRound {
    public var radius: CGFloat
    public var corners: CACornerMask

    public init(
        radius: CGFloat,
        corners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    ) {
        self.radius = radius
        self.corners = corners
    }
}

public struct Shadow {
    public var color: UIColor
    public var fillColor: UIColor
    public var opacity: Float
    public var offset: CGSize
    public var radius: CGFloat
    public var cornerRadii: CGSize
    public var corners: UIRectCorner

    public init(
        color: UIColor,
        fillColor: UIColor,
        opacity: Float,
        offset: CGSize,
        radius: CGFloat,
        cornerRadii: CGSize = .zero,
        corners: UIRectCorner = .allCorners
    ) {
        self.color = color
        self.fillColor = fillColor
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
        self.cornerRadii = cornerRadii
        self.corners = corners
    }

    public func hasRoundCorners() -> Bool {
        return
            cornerRadii != .zero &&
            corners != []
    }
}

public struct Border {
    public var color: UIColor
    public var width: CGFloat
    
    public init(
        color: UIColor,
        width: CGFloat
    ) {
        self.color = color
        self.width = width
    }
}
