// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias NavigationBarStyle = BaseStyle<NavigationBarStyleAttribute>

public enum NavigationBarStyleAttribute: BaseStyleAttribute {
    /// <mark>
    /// Base
    case backgroundColor(Color)
    case tintColor(Color)
    case isInteractable(Bool)

    /// <mark>
    /// NavigationBar
    case opaque
    case backgroundImage(Image?)
    case shadowImage(Image?)
    case shadowColor(Color?)
    case titleAttributes([NSAttributedString.Key: Any])
    /// <note>
    /// `Large Title`s are also enabled for the navigation bar.
    case largeTitleAttributes([NSAttributedString.Key: Any])
}

extension NavigationBarStyleAttribute {
    public var id: String {
        switch self {
        case .backgroundColor: return Self.getBackgroundColorAttributeId()
        case .tintColor: return Self.getTintColorAttributeId()
        case .isInteractable: return Self.getIsInteractableAttributeId()
        case .opaque: return "navigationBar.opaque"
        case .backgroundImage: return "navigationBar.backgroundImage"
        case .shadowImage: return "navigationBar.shadowImage"
        case .shadowColor: return "navigationBar.shadowColor"
        case .titleAttributes: return "navigationBar.titleAttributes"
        case .largeTitleAttributes: return "navigationBar.largeTitleAttributes"
        }
    }
}
