// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol TabBarItemConvertible {
    var name: String { get } /// <warning> No internal checking so it is up to the application to set a unique name.
    var barButtonItem: TabBarButtonItemConvertible { get }
    var screen: UIViewController? { get }
}

extension TabBarItemConvertible {
    public func equalsTo(_ other: TabBarItemConvertible?) -> Bool {
        if let other = other {
            return name == other.name
        }
        return false
    }
}

public struct FixedSpaceTabBarItem: TabBarItemConvertible {
    public let name: String
    public let barButtonItem: TabBarButtonItemConvertible
    public let screen: UIViewController?

    public init(
        name: String,
        width: CGFloat
    ) {
        self.name = name
        self.barButtonItem = TabBarButtonItem(width: width)
        self.screen = nil
    }

    private struct TabBarButtonItem: TabBarButtonItemConvertible {
        let style: ButtonStyling
        let spacingBetweenImageAndTitle: CGFloat
        let width: CGFloat
        let isSelectable: Bool

        init(width: CGFloat) {
            self.style = NoButtonStyle()
            self.spacingBetweenImageAndTitle = 0.0
            self.width = width
            self.isSelectable = false
        }
    }
}
