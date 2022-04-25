// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UIViewController {
    public var tabBarContainer: TabBarContainer? {
        var parentContainer = parent

        while parentContainer != nil {
            if let tabBarContainer = parentContainer as? TabBarContainer {
                return tabBarContainer
            }

            parentContainer = parentContainer?.parent
        }

        return nil
    }
}
