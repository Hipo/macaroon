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

public struct LayoutEdgesMetric {
    public let top: LayoutMetric
    public let left: LayoutMetric
    public let bottom: LayoutMetric
    public let right: LayoutMetric

    public init(
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

extension LayoutEdgesMetric: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}

public struct LayoutCenterMetric {
    public let x: LayoutMetric
    public let y: LayoutMetric

    public init(
        x: LayoutMetric = nil,
        y: LayoutMetric = nil
    ) {
        self.x = x
        self.y = y
    }
}

extension LayoutCenterMetric: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}

public struct LayoutSizeMetric {
    public let width: LayoutMetric
    public let height: LayoutMetric

    public init(
        width: LayoutMetric = nil,
        height: LayoutMetric = nil
    ) {
        self.width = width
        self.height = height
    }
}

extension LayoutSizeMetric: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}
