// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct ViewStyle: BaseStyle {
    public var backgroundColor: Color?
    public var tintColor: Color?
    public var isInteractable: Bool?

    public init(
        attributes: [Attribute]
    ) {
        attributes.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor): self.backgroundColor = backgroundColor
            case .tintColor(let tintColor): self.tintColor = tintColor
            case .isInteractable(let interactable): self.isInteractable = interactable
            }
        }
    }
}

extension ViewStyle {
    public func modify(
        _ modifiers: ViewStyle...
    ) -> ViewStyle {
        var modifiedStyle = ViewStyle()
        modifiedStyle.backgroundColor = modifiers.last(existing: \.backgroundColor) ?? backgroundColor
        modifiedStyle.tintColor = modifiers.last(existing: \.tintColor) ?? tintColor
        modifiedStyle.isInteractable = modifiers.last(existing: \.isInteractable) ?? isInteractable
        return modifiedStyle
    }
}

extension ViewStyle {
    public enum Attribute: BaseStyleAttribute {
        case backgroundColor(Color)
        case tintColor(Color)
        case isInteractable(Bool)
    }
}
