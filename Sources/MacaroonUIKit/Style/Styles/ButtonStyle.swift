// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ButtonStyle: BaseStyle {
    public var font: Font?
    public var titleColor: ColorGroup?
    public var title: Text?
    public var icon: ImageGroup?
    public var backgroundImage: ImageGroup?
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .font(let font): self.font = font
            case .titleColor(let titleColor): self .titleColor = titleColor
            case .title(let title): self.title = title
            case .icon(let icon): self.icon = icon
            case .backgroundImage(let backgroundImage): self.backgroundImage = backgroundImage
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension ButtonStyle {
    public func modify(
        _ modifiers: ButtonStyle...
    ) -> ButtonStyle {
        var modifiedStyle = ButtonStyle()
        modifiedStyle.font = modifiers.last(existing: \.font) ?? font
        modifiedStyle.titleColor = modifiers.last(existing: \.titleColor) ?? titleColor
        modifiedStyle.title = modifiers.last(existing: \.title) ?? title
        modifiedStyle.icon = modifiers.last(existing: \.icon) ?? icon
        modifiedStyle.backgroundImage = modifiers.last(existing: \.backgroundImage) ?? backgroundImage
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension ButtonStyle {
    public enum Attribute: BaseStyleAttribute {
        case font(Font)
        case titleColor(ColorGroup)
        case title(Text)
        case icon(ImageGroup)
        case backgroundImage(ImageGroup)
        case backgroundColor(Color)
        case tintColor(Color)
        case isInteractable(Bool)
    }
}
