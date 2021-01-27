// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Transition {
    var source: ScreenRoutable? { get set }
    var destination: [ScreenRoutable] { get set }
    var completion: (() -> Void)? { get set }

    func perform(animated: Bool)
}
