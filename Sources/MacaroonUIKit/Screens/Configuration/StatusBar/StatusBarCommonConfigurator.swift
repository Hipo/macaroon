/// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class StatusBarCommonConfigurator: ScreenLifeCycleObserver {
    init() {}
}

/// <mark>
/// ScreenLifeCycleObserver
extension StatusBarCommonConfigurator {

    public func viewWillAppear(
        _ screen: Screen
    ) {
        screen.statusBarController.setNeedsStatusBarAppearanceUpdateOnBeingAppeared()
    }
    
    public func viewWillDisappear(
        _ screen: Screen
    ) {
        screen.statusBarController.setNeedsStatusBarAppearanceUpdateOnBeingDisappeared()
    }
}
