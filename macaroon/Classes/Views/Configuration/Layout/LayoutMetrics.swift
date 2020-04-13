// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct LayoutMetric {
    public let min: CGFloat
    public let equal: CGFloat
    public let max: CGFloat

    public init(
        min: CGFloat = UIView.noIntrinsicMetric,
        equal: CGFloat = UIView.noIntrinsicMetric,
        max: CGFloat = UIView.noIntrinsicMetric
    ) {
        self.min = min
        self.equal = equal
        self.max = max
    }
}

extension LayoutMetric: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(equal: CGFloat(value))
    }
}

extension LayoutMetric: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}

public struct LayoutEdgesMetrics {
    public let top: LayoutMetric
    public let left: LayoutMetric
    public let bottom: LayoutMetric
    public let right: LayoutMetric

    init(
        top: LayoutMetric = nil,
        left: LayoutMetric = nil,
        bottom: LayoutMetric = nil,
        right: LayoutMetric = nil
    ) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}

public struct LayoutCenterMetrics {
    public let x: LayoutMetric
    public let y: LayoutMetric

    init(
        x: LayoutMetric = nil,
        y: LayoutMetric = nil
    ) {
        self.x = x
        self.y = y
    }
}

public struct LayoutSizeMetrics {
    public let width: LayoutMetric
    public let height: LayoutMetric

    init(
        width: LayoutMetric = nil,
        height: LayoutMetric = nil
    ) {
        self.width = width
        self.height = height
    }
}
