// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public struct AttributedText {
    public let string: String
    public let attributes: TextAttributes

    public init(
        string: String,
        attributes: TextAttributes
    ) {
        self.string = string
        self.attributes = attributes
    }
}

public protocol TextAttribute: Identifiable {
    typealias SystemAttributes = Dictionary<NSAttributedString.Key, Any>

    func apply(
        to systemAttributes: inout SystemAttributes
    )

    func convertToSystemAttributes() -> SystemAttributes
}

extension TextAttribute {
    public var id: String {
        return String(describing: Self.self)
    }
}

public struct AnyTextAttribute: TextAttribute {
    public let id: String

    private let _convertToSystemAttributes: () -> SystemAttributes
    private let _apply: (inout SystemAttributes) -> Void

    public init<T: TextAttribute>(
        _ textAttribute: T
    ) {
        self.id = textAttribute.id
        self._apply = textAttribute.apply
        self._convertToSystemAttributes = textAttribute.convertToSystemAttributes
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        _apply(&systemAttributes)
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return _convertToSystemAttributes()
    }
}

extension AnyTextAttribute {
    public static func font(
        _ font: Font
    ) -> Self {
        return AnyTextAttribute(
            FontTextAttribute(font)
        )
    }

    public static func letterSpacing(
        _ spacing: CGFloat
    ) -> Self {
        return AnyTextAttribute(
            LetterSpacingTextAttribute(spacing)
        )
    }

    public static func paragraph(
        _ paragraph: ParagraphAttributes
    ) -> Self {
        return AnyTextAttribute(
            ParagraphTextAttribute(paragraph)
        )
    }

    public static func textColor(
        _ color: Color
    ) -> Self {
        return AnyTextAttribute(
            TextColorTextAttribute(color)
        )
    }

    public static func underlineStyle(
        _ color: Color,
        _ style: NSUnderlineStyle = .single
    ) -> Self {
        return AnyTextAttribute(
            UnderlineStyleTextAttribute(color, style)
        )
    }
}

public struct FontTextAttribute: TextAttribute {
    public let value: UIFont

    public init(
        _ font: Font
    ) {
        self.value = font.uiFont
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        systemAttributes[.font] = value
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return [
            .font: value
        ]
    }
}

public struct LetterSpacingTextAttribute: TextAttribute {
    public let value: CGFloat

    public init(
        _ value: CGFloat
    ) {
        self.value = value
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        systemAttributes[.kern] = value
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return [
            .kern: value
        ]
    }
}

public struct ParagraphTextAttribute: TextAttribute {
    public let paragraph: ParagraphAttributes

    public init(
        _ paragraph: ParagraphAttributes
    ) {
        self.paragraph = paragraph
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        systemAttributes[.paragraphStyle] = paragraph.convertToSystemAttributes()
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return [
            :
        ]
    }
}

public struct TextColorTextAttribute: TextAttribute {
    public let value: UIColor

    public init(
        _ color: Color
    ) {
        self.value = color.uiColor
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        systemAttributes[.foregroundColor] = value
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return [
            .foregroundColor: value
        ]
    }
}

public struct UnderlineStyleTextAttribute: TextAttribute {
    public let color: UIColor
    public let style: NSUnderlineStyle

    public init(
        _ color: Color,
        _ style: NSUnderlineStyle = .single
    ) {
        self.color = color.uiColor
        self.style = style
    }

    public func apply(
        to systemAttributes: inout SystemAttributes
    ) {
        systemAttributes[.underlineColor] = color
        systemAttributes[.underlineStyle] = style.rawValue
    }

    public func convertToSystemAttributes() -> SystemAttributes {
        return [
            .underlineColor: color,
            .underlineStyle: style.rawValue
        ]
    }
}

public typealias TextAttributes = Set<AnyTextAttribute>

extension TextAttributes {
    public func convertToSystemAttributes() -> Element.SystemAttributes {
        var systemAttributes: Element.SystemAttributes = [:]
        forEach { $0.apply(to: &systemAttributes) }
        return systemAttributes
    }
}

public protocol ParagraphAttribute: Identifiable {
    typealias SystemAttributes = NSMutableParagraphStyle

    func apply(
        to systemAttributes: SystemAttributes
    )
}

extension ParagraphAttribute {
    public var id: String {
        return String(describing: Self.self)
    }
}

public struct AnyParagraphAttribute: ParagraphAttribute {
    public let id: String

    private let _apply: (NSMutableParagraphStyle) -> Void

    public init<T: ParagraphAttribute>(
        _ paragraphAttribute: T
    ) {
        self.id = paragraphAttribute.id
        self._apply = paragraphAttribute.apply
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        _apply(systemAttributes)
    }
}

extension AnyParagraphAttribute {
    public static func lineBreakMode(
        _ lineBreakMode: NSLineBreakMode
    ) -> Self {
        return AnyParagraphAttribute(
            LineBreakModeParagraphAttribute(lineBreakMode)
        )
    }

    public static func lineHeight(
        _ height: CGFloat
    ) -> Self {
        return AnyParagraphAttribute(
            LineHeightParagraphAttribute(height)
        )
    }

    public static func lineHeightMultiple(
        _ multiplier: CGFloat
    ) -> Self {
        return AnyParagraphAttribute(
            LineHeightMultipleParagraphAttribute(multiplier)
        )
    }

    public static func lineSpacing(
        _ spacing: CGFloat
    ) -> Self {
        return AnyParagraphAttribute(
            LineSpacingParagraphAttribute(spacing)
        )
    }

    public static func maxLineHeight(
        _ height: CGFloat
    ) -> Self {
        return AnyParagraphAttribute(
            MaxLineHeightParagraphAttribute(height)
        )
    }
    public static func minLineHeight(
        _ height: CGFloat
    ) -> Self {
        return AnyParagraphAttribute(
            MinLineHeightParagraphAttribute(height)
        )
    }

    public static func textAlignment(
        _ alignment: NSTextAlignment
    ) -> Self {
        return AnyParagraphAttribute(
            TextAlignmentParagraphAttribute(alignment)
        )
    }
}

public struct LineBreakModeParagraphAttribute: ParagraphAttribute {
    public let lineBreakMode: NSLineBreakMode

    public init(
        _ lineBreakMode: NSLineBreakMode
    ) {
        self.lineBreakMode = lineBreakMode
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.lineBreakMode = lineBreakMode
    }
}

public struct LineHeightParagraphAttribute: ParagraphAttribute {
    public let height: CGFloat

    public init(
        _ height: CGFloat
    ) {
        self.height = height
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.minimumLineHeight = height
        systemAttributes.maximumLineHeight = height
    }
}

public struct LineHeightMultipleParagraphAttribute: ParagraphAttribute {
    public let multiplier: CGFloat

    public init(
        _ multiplier: CGFloat
    ) {
        self.multiplier = multiplier
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.lineHeightMultiple = multiplier
    }
}

public struct LineSpacingParagraphAttribute: ParagraphAttribute {
    public let spacing: CGFloat

    public init(
        _ spacing: CGFloat
    ) {
        self.spacing = spacing
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.lineSpacing = spacing
    }
}

public struct MaxLineHeightParagraphAttribute: ParagraphAttribute {
    public let height: CGFloat

    public init(
        _ height: CGFloat
    ) {
        self.height = height
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.maximumLineHeight = height
    }
}

public struct MinLineHeightParagraphAttribute: ParagraphAttribute {
    public let height: CGFloat

    public init(
        _ height: CGFloat
    ) {
        self.height = height
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.minimumLineHeight = height
    }
}

public struct TextAlignmentParagraphAttribute: ParagraphAttribute {
    public let alignment: NSTextAlignment

    public init(
        _ alignment: NSTextAlignment
    ) {
        self.alignment = alignment
    }

    public func apply(
        to systemAttributes: SystemAttributes
    ) {
        systemAttributes.alignment = alignment
    }
}

public typealias ParagraphAttributes = Set<AnyParagraphAttribute>

extension ParagraphAttributes {
    public func convertToSystemAttributes() -> NSParagraphStyle {
        let systemAttributes = Element.SystemAttributes()
        forEach { $0.apply(to: systemAttributes) }
        return systemAttributes
    }
}
