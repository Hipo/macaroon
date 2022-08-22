// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol UIInteraction {
    func setSelector(_ selector: (() -> Void)?)

    func attach(to view: UIView)
    func detachFromView()

    func publish()
}
