// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TabBarPresentable: ViewLaunchable where ViewLaunchArgs: TabBarLaunchArgsConvertible {
    var barButtonItems: [TabBarButtonItemConvertible] { get set }
    var selectedBarButtonIndex: Int? { get set }
    var barButtonDidSelect: ((Int) -> Void)? { get set }
}

public protocol TabBarLaunchArgsConvertible: ViewLaunchArgsConvertible where StyleGuide: TabBarStyleGuideConvertible { }

public protocol TabBarStyleGuideConvertible: StyleGuideConvertible { }

public struct TabBarLaunchArgs<StyleGuide: TabBarStyleGuideConvertible>: TabBarLaunchArgsConvertible {
    public let styleGuide: StyleGuide

    public init(_ styleGuide: StyleGuide) {
        self.styleGuide = styleGuide
    }
}
