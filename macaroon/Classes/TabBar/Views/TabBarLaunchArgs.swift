// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct TabBarLaunchArgs: ViewLaunchArgsConvertible {
    public let style: Styling

    public init(_ style: Styling) {
        self.style = style
    }
}
