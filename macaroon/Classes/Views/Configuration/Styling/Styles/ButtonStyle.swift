// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias ButtonStyle = BaseStyle<ButtonStyleAttribute>

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
            case .border(let border):
                derivedButtonStyle.append(.border(border))
            case .corner(let corner):
                derivedButtonStyle.append(.corner(corner))
            case .shadow(let shadow):
                derivedButtonStyle.append(.shadow(shadow))
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
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)

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
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        case .backgroundImage: return "button.backgroundImage"
        case .icon: return "button.icon"
        case .font: return "button.font"
        case .titleColor: return "button.titleColor"
        case .title: return "button.title"
        }
    }
}
