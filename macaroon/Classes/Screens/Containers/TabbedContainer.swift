// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabbedContainer: Container {
    var selectedScreen: UIViewController? { get }
}

extension UITabBarController: TabbedContainer {
    public var selectedScreen: UIViewController? {
        return selectedViewController
    }
}
