// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarItem {
    /// <note>
    /// Should be unique.
    var id: String { get }
    var barButtonItem: TabBarButtonItem { get }
    var screen: UIViewController? { get }

    /// <note>
    /// The explicit width for the tabbar item.
    var width: LayoutMetric { get }

    /// <note>
    /// Nothing will happen when tapping on the item if `isSelectable` is false.
    var isSelectable: Bool { get }
}

extension TabBarItem {
    public var width: LayoutMetric {
        return .noMetric
    }

    public var isSelectable: Bool {
        return true
    }
}

public protocol TabBarButtonItem {
    var style: ButtonStyle { get }
    var spacingBetweenIconAndTitle: LayoutMetric { get }

    var badgeStyle: ButtonStyle? { get }
    var badgePositionAdjustment: CGPoint? { get }
}

extension TabBarButtonItem {
    public var badgeStyle: ButtonStyle? {
        return nil
    }
    public var badgePositionAdjustment: CGPoint? {
        return .zero
    }
}

public struct FixedSpaceTabBarItem: TabBarItem {
    public let id: String
    public let barButtonItem: TabBarButtonItem
    public let screen: UIViewController?
    public let width: LayoutMetric
    public let isSelectable: Bool

    public init(
        width: CGFloat
    ) {
        self.id = UUID().uuidString
        self.barButtonItem = FixedSpaceTabBarButtonItem()
        self.screen = nil
        self.width = width
        self.isSelectable = false
    }
}

extension FixedSpaceTabBarItem {
    private struct FixedSpaceTabBarButtonItem: TabBarButtonItem {
        let style: ButtonStyle
        let spacingBetweenIconAndTitle: CGFloat

        init() {
            self.style = []
            self.spacingBetweenIconAndTitle = 0
        }
    }
}
