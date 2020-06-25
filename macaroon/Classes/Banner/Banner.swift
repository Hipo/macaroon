// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Banner {
    var name: String { get }
    var contentView: UIControl { get }
    var duration: TimeInterval { get }
}

extension Banner {
    public var duration: TimeInterval {
        return 3.0
    }
}
