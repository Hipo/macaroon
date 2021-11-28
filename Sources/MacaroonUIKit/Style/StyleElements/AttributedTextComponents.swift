// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public struct AttributedTextComponents {
    public var text: String? {
        didSet { textDidEdit(from: oldValue) }
    }
    public var attributes: TextAttributeGroup? {
        didSet { attributesDidEdit() }
    }

    public private(set) var attributedText: NSAttributedString?

    public init(
        text: String?,
        attributes: TextAttributeGroup? = nil
    ) {
        self.text = text
        self.attributes = attributes
        self.attributedText =
            text.unwrap {
                AttributedTextComponents.generateAttributedText(
                    $0,
                    attributes: attributes
                )
            }
    }
}

extension AttributedTextComponents {
    private mutating func textDidEdit(
        from oldText: String?
    ) {
        if text != oldText {
            updateAttributedText()
        }
    }

    private mutating func attributesDidEdit() {
        updateAttributedText()
    }

    private mutating func updateAttributedText() {
        attributedText =
            text.unwrap {
                AttributedTextComponents.generateAttributedText(
                    $0,
                    attributes: attributes
                )
            }
    }
}

extension AttributedTextComponents {
    private static func generateAttributedText(
        _ text: String,
        attributes: TextAttributeGroup?
    ) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attributes?.asSystemAttributes())
    }
}

public protocol TextAttribute: Identifiable {
    typealias SystemAttributeGroup = Dictionary<NSAttributedString.Key, Any>

    func apply(
        to systemAttributes: inout SystemAttributeGroup
    )
}

extension TextAttribute {
    public var id: String {
        return String(describing: Self.self)
    }
}

public struct AnyTextAttribute: TextAttribute {
    public let id: String

    private let _apply: (inout SystemAttributeGroup) -> Void

    public init<T: TextAttribute>(
        _ textAttribute: T
    ) {
        self.id = textAttribute.id
        self._apply = textAttribute.apply
    }

    public func apply(
        to systemAttributes: inout SystemAttributeGroup
    ) {
        _apply(&systemAttributes)
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
        _ paragraph: ParagraphAttributeGroup
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
        to systemAttributes: inout SystemAttributeGroup
    ) {
        systemAttributes[.font] = value
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
        to systemAttributes: inout SystemAttributeGroup
    ) {
        systemAttributes[.kern] = value
    }
}

public struct ParagraphTextAttribute: TextAttribute {
    public let paragraph: ParagraphAttributeGroup

    public init(
        _ paragraph: ParagraphAttributeGroup
    ) {
        self.paragraph = paragraph
    }

    public func apply(
        to systemAttributes: inout SystemAttributeGroup
    ) {
        systemAttributes[.paragraphStyle] = paragraph.asSystemAttributes()
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
        to systemAttributes: inout SystemAttributeGroup
    ) {
        systemAttributes[.foregroundColor] = value
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
        to systemAttributes: inout SystemAttributeGroup
    ) {
        systemAttributes[.underlineColor] = color
        systemAttributes[.underlineStyle] = style.rawValue
    }
}

public typealias TextAttributeGroup = Set<AnyTextAttribute>

extension TextAttributeGroup {
    public func asSystemAttributes() -> Element.SystemAttributeGroup {
        var systemAttributes: Element.SystemAttributeGroup = [:]
        forEach { $0.apply(to: &systemAttributes) }
        return systemAttributes
    }
}

public protocol ParagraphAttribute: Identifiable {
    typealias SystemAttributeGroup = NSMutableParagraphStyle

    func apply(
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
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
        to systemAttributes: SystemAttributeGroup
    ) {
        systemAttributes.alignment = alignment
    }
}

public typealias ParagraphAttributeGroup = Set<AnyParagraphAttribute>

extension ParagraphAttributeGroup {
    public func asSystemAttributes() -> NSParagraphStyle {
        let systemAttributes = Element.SystemAttributeGroup()
        forEach { $0.apply(to: systemAttributes) }
        return systemAttributes
    }
}

extension String {
    public func attributed(
        _ attributes: TextAttributeGroup
    ) -> NSAttributedString {
        let components = AttributedTextComponents(text: self, attributes: attributes)
        return components.attributedText ?? NSAttributedString()
    }
}
