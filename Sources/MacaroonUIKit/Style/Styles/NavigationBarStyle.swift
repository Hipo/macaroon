// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct NavigationBarStyle: BaseStyle {
    public var isOpaque: Bool?
    public var titleAttributes: [NSAttributedString.Key: Any]?
    public var largeTitleAttributes: [NSAttributedString.Key: Any]?
    public var backImage: Image?
    public var shadowImage: Image?
    public var shadowColor: Color?
    public var backgroundImage: Image?
    public var backgroundColor: Color?
    public var tintColor: Color?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .isOpaque(let opaque): self.isOpaque = opaque
            case .titleAttributes(let titleAttributes): self.titleAttributes = titleAttributes
            case .largeTitleAttributes(let largeTitleAttributes): self.largeTitleAttributes = largeTitleAttributes
            case .backImage(let backImage): self.backImage = backImage
            case .shadowImage(let shadowImage): self.shadowImage = shadowImage
            case .shadowColor(let shadowColor): self.shadowColor = shadowColor
            case .backgroundImage(let backgroundImage): self.backgroundImage = backgroundImage
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            }
        }
    }
}

extension NavigationBarStyle {
    public func modify(
        _ modifiers: NavigationBarStyle...
    ) -> NavigationBarStyle {
        var modifiedStyle = NavigationBarStyle()
        modifiedStyle.isOpaque = modifiers.last(existing: \.isOpaque) ?? isOpaque
        modifiedStyle.titleAttributes = modifiers.last(existing: \.titleAttributes) ?? titleAttributes
        modifiedStyle.largeTitleAttributes = modifiers.last(existing: \.largeTitleAttributes) ?? largeTitleAttributes
        modifiedStyle.backImage = modifiers.last(existing: \.backImage) ?? backImage
        modifiedStyle.shadowImage = modifiers.last(existing: \.shadowImage) ?? shadowImage
        modifiedStyle.shadowColor = modifiers.last(existing: \.shadowColor) ?? shadowColor
        modifiedStyle.backgroundImage = modifiers.last(existing: \.backgroundImage) ?? backgroundImage
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isOpaque = modifiers.last(existing: \.isOpaque) ?? isOpaque
        return modifiedStyle
    }
}

extension NavigationBarStyle {
    public enum Attribute: BaseStyleAttribute {
        case isOpaque(Bool)
        case titleAttributes([NSAttributedString.Key: Any])
        case largeTitleAttributes([NSAttributedString.Key: Any])
        case backImage(Image?)
        case shadowImage(Image?)
        case shadowColor(Color?)
        case backgroundImage(Image?)
        case backgroundColor(Color)
        case tintColor(Color)
    }
}
