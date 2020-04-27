// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarButtonItemConvertible {
    var style: ButtonStyling { get }
    var badgeStyle: ButtonStyling? { get }
    var badgePositionAdjustment: CGPoint? { get }
    var spacingBetweenImageAndTitle: CGFloat { get }
    var width: CGFloat { get } /// <note> The explicit width for the tabbar button
    var isSelectable: Bool { get }
}

extension TabBarButtonItemConvertible {
    public var badgeStyle: ButtonStyling? {
        return nil
    }
    public var badgePositionAdjustment: CGPoint? {
        return .zero
    }
}
