// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct TextStyle: BaseStyle {
    public var font: Font?
    public var adjustsFontForContentSizeCategory: Bool?
    public var textColor: Color?
    public var textAlignment: NSTextAlignment?
    public var textOverflow: TextOverflow?
    public var text: Text?
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .font(let font): self.font = font
            case .adjustsFontForContentSizeCategory(let boolean): self.adjustsFontForContentSizeCategory = boolean
            case .textColor(let textColor): self.textColor = textColor
            case .textAlignment(let textAlignment): self.textAlignment = textAlignment
            case .textOverflow(let textOverflow): self.textOverflow = textOverflow
            case .text(let text): self.text = text
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension TextStyle {
    public func modify(
        _ modifiers: TextStyle...
    ) -> TextStyle {
        var modifiedStyle = TextStyle()
        modifiedStyle.font = modifiers.last(existing: \.font) ?? font
        modifiedStyle.adjustsFontForContentSizeCategory = modifiers.last(existing: \.adjustsFontForContentSizeCategory) ?? adjustsFontForContentSizeCategory
        modifiedStyle.textColor = modifiers.last(existing: \.textColor) ?? textColor
        modifiedStyle.textAlignment = modifiers.last(existing: \.textAlignment) ?? textAlignment
        modifiedStyle.textOverflow = modifiers.last(existing: \.textOverflow) ?? textOverflow
        modifiedStyle.text = modifiers.last(existing: \.text) ?? text
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension TextStyle {
    public enum Attribute: BaseStyleAttribute {
        case font(Font)
        case adjustsFontForContentSizeCategory(Bool)
        case textColor(Color)
        case textAlignment(NSTextAlignment)
        case textOverflow(TextOverflow)
        case text(Text)
        case backgroundColor(Color)
        case tintColor(Color)
        case isInteractable(Bool)
    }
}
