// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct PageControlStyle: BaseStyle {
    public var indicatorColor: Color?
    public var indicatorImage: Image?
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .indicatorColor(let indicatorColor): self.indicatorColor = indicatorColor
            case .indicatorImage(let indicatorImage): self.indicatorImage = indicatorImage
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension PageControlStyle {
    public func modify(
        _ modifiers: PageControlStyle...
    ) -> PageControlStyle {
        var modifiedStyle = PageControlStyle()
        modifiedStyle.indicatorColor = modifiers.last(existing: \.indicatorColor) ?? indicatorColor
        modifiedStyle.indicatorImage = modifiers.last(existing: \.indicatorImage) ?? indicatorImage
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension PageControlStyle {
    public enum Attribute: BaseStyleAttribute {
        case indicatorColor(Color)

        /// <warning>
        /// It has no effect below iOS 14.
        case indicatorImage(Image)

        case backgroundColor(Color)
        case tintColor(Color)
        case isInteractable(Bool)
    }
}
