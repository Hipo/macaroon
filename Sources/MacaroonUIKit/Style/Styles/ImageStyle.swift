// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ImageStyle: BaseStyle {
    public var image: Image?
    public var contentMode: UIView.ContentMode?
    public var adjustsImageForContentSizeCategory: Bool?
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .image(let image): self.image = image
            case .contentMode(let contentMode): self.contentMode = contentMode
            case .adjustsImageForContentSizeCategory(let boolean): self.adjustsImageForContentSizeCategory = boolean
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension ImageStyle {
    public func modify(
        _ modifiers: ImageStyle...
    ) -> ImageStyle {
        var modifiedStyle = ImageStyle()
        modifiedStyle.image = modifiers.last(existing: \.image) ?? image
        modifiedStyle.contentMode = modifiers.last(existing: \.contentMode) ?? contentMode
        modifiedStyle.adjustsImageForContentSizeCategory = modifiers.last(existing: \.adjustsImageForContentSizeCategory) ?? adjustsImageForContentSizeCategory
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension ImageStyle {
    public static func scaleToFill(
        _ image: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.contentMode = .scaleToFill
        style.image = image
        return style
    }

    public static func aspectFit(
        _ image: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.contentMode = .scaleAspectFit
        style.image = image
        return style
    }

    public static func aspectFill(
        _ image: Image? = nil
    ) -> ImageStyle {
        var style = ImageStyle()
        style.contentMode = .scaleAspectFill
        style.image = image
        return style
    }
}

extension ImageStyle {
    public enum Attribute: BaseStyleAttribute {
        case image(Image)
        case contentMode(UIView.ContentMode)
        case adjustsImageForContentSizeCategory(Bool)
        case backgroundColor(Color)
        case tintColor(Color)
        case isInteractable(Bool)
    }
}
