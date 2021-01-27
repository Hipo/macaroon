// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias NavigationBarStyle = BaseStyle<NavigationBarStyleAttribute>

public enum NavigationBarStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)

    /// <mark>
    /// NavigationBar
    case font(Font)
    case textColor(Color)
}

extension NavigationBarStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        case .font: return "navigationBar.font"
        case .textColor: return "navigationBar.textColor"
        }
    }
}
