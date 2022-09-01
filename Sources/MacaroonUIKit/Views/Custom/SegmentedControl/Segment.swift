// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Segment {
    var layout: Button.Layout { get }
    var style: ButtonStyle { get }
    var contentEdgeInsets: UIEdgeInsets? { get }
}

extension Segment {
    public var layout: Button.Layout {
        return .none
    }
}
