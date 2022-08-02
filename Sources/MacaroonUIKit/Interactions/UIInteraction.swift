// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol UIInteraction {
    typealias Handler = () -> Void

    func setHandler(
        _ handler: Handler?
    )

    func attach(
        to view: UIView
    )
    func detachFromView()
}
