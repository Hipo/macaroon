// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias TextStyle = BaseStyle<TextStyleAttribute>

extension TextStyle {
    public func mutate(
        by viewStyle: ViewStyle
    ) -> Self {
        var derivedTextStyle: TextStyle = []

        viewStyle.forEach {
            switch $0 {
            case .backgroundColor(let backgroundColor):
                derivedTextStyle.append(.backgroundColor(backgroundColor))
            case .tintColor(let tintColor):
                derivedTextStyle.append(.tintColor(tintColor))
            case .border(let border):
                derivedTextStyle.append(.border(border))
            case .corner(let corner):
                derivedTextStyle.append(.corner(corner))
            case .shadow(let shadow):
                derivedTextStyle.append(.shadow(shadow))
            }
        }

        return mutate(by: derivedTextStyle)
    }
}

public enum TextStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)

    /// <mark>
    /// Text
    case font(Font)
    case textAlignment(NSTextAlignment)
    case textOverflow(TextOverflow)
    case textColor(Color)
    case content(Text)
}

extension TextStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        case .font: return "text.font"
        case .textAlignment: return "text.textAlignment"
        case .textOverflow: return "text.textOverflow"
        case .textColor: return "text.textColor"
        case .content: return "text.content"
        }
    }
}
