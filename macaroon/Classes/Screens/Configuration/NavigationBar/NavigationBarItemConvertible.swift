// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NavigationBarItemConvertible {
    typealias InteractionHandler = () -> Void

    var style: ButtonStyle { get }
    var size: NavigationBarButtonSize { get }
    var handler: InteractionHandler { get }

    func asSystemBarButtonItem() -> UIBarButtonItem
}

extension NavigationBarItemConvertible {
    public func asSystemBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: NavigationBarButton(self))
    }
}

public enum NavigationBarButtonSize {
    case fixed(CGSize = CGSize(width: 44.0, height: 44.0), Alignment = .none)
    case dynamic(UIEdgeInsets = .zero)

    public enum Alignment {
        case none
        case horizontal(UIControl.ContentHorizontalAlignment)
        case vertical(UIControl.ContentVerticalAlignment)
    }
}
