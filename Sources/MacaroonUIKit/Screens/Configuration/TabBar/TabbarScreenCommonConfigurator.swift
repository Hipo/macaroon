// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class TabbarScreenCommonConfigurator: ScreenLifeCycleObserver {
    init() {}
}

/// <mark>
/// ScreenLifeCycleObserver
extension TabbarScreenCommonConfigurator {
    public func viewWillAppear(
        _ screen: Screen
    ) {
        screen.tabbarController.setNeedsTabBarAppearanceUpdateOnAppearing(animated: true)
    }

    public func viewDidAppear(
        _ screen: Screen
    ) {
        screen.tabbarController.setNeedsTabBarAppearanceUpdateOnAppeared()
    }
    
    public func viewDidDisappear(
        _ screen: Screen
    ) {
        screen.tabbarController.setNeedsTabBarAppearanceUpdateOnDisappeared()
    }
}

