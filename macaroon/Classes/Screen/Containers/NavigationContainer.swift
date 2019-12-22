// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class NavigationContainer: UINavigationController, ScreenComposable {
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    open func customizeAppearance() {
        customizeNavigationBarAppearance()
        customizeViewAppearance()
    }

    open func customizeNavigationBarAppearance() { }
    open func customizeViewAppearance() { }
    open func prepareLayout() { }
    open func setListeners() { }
    open func linkInteractors() { }

    open override func viewDidLoad() {
        super.viewDidLoad()
        compose()
    }
}
