// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias ViewStyle = BaseStyle<ViewStyleAttribute>

public enum ViewStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case border(Border)
    case corner(Corner)
    case shadow(Shadow)
}

extension ViewStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .border: return Self.getBorderAttributeId()
        case .corner: return Self.getCornerAttributeId()
        case .shadow: return Self.getShadowAttributeId()
        }
    }
}
