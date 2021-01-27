// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarButtonItemConvertible {
    var style: ButtonStyle { get }
    var badgeStyle: ButtonStyle? { get }
    var badgePositionAdjustment: CGPoint? { get }
    var spacingBetweenImageAndTitle: CGFloat { get }
    var width: CGFloat { get } /// <note> The explicit width for the tabbar button
    var isSelectable: Bool { get }
}

extension TabBarButtonItemConvertible {
    public var badgeStyle: ButtonStyle? {
        return nil
    }
    public var badgePositionAdjustment: CGPoint? {
        return .zero
    }
}
