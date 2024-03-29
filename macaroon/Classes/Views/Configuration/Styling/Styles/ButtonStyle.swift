// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias ButtonStyle = BaseStyle<ButtonStyleAttribute>

extension ButtonStyle {
    public var font: Font? {
        for attribute in self {
            switch attribute {
            case .font(let font): return font
            default: break
            }
        }

        return nil
    }

    public var titleColor: Color? {
        for attribute in self {
            switch attribute {
            case .titleColor(let titleColor): return titleColor
            default: break
            }
        }

        return nil
    }
}

extension ButtonStyle {
    public func mutate(
        by viewStyle: ViewStyle
    ) -> Self {
        var derivedButtonStyle: ButtonStyle = []

        viewStyle.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                derivedButtonStyle.append(.backgroundColor(backgroundColor))
            case .tintColor(let tintColor):
                derivedButtonStyle.append(.tintColor(tintColor))
            case .isInteractable(let isInteractable):
                derivedButtonStyle.append(.isInteractable(isInteractable))
            }
        }

        return mutate(by: derivedButtonStyle)
    }
}

public enum ButtonStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case isInteractable(Bool)

    /// <mark>
    /// Button
    case backgroundImage(Image)
    case icon(Image)
    case font(Font)
    case titleColor(Color)
    case title(Text)
}

extension ButtonStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .isInteractable: return Self.getIsInteractableAttributeId()
        case .backgroundImage: return "button.backgroundImage"
        case .icon: return "button.icon"
        case .font: return "button.font"
        case .titleColor: return "button.titleColor"
        case .title: return "button.title"
        }
    }
}
