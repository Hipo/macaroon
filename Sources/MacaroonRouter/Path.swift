// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

/// <note>
/// Identifies a single screen.
public protocol Path {
    typealias ScreenBuilder = () -> ScreenRoutable

    /// <note>
    /// It should be unique for every path out there.
    var identifier: String { get }
    var build: ScreenBuilder { get }
}

/// <note>
/// Identifies a pre-defined path in a flow.
public enum ExistingPath {
    case initial
    /// <note>
    /// Shows the visible path
    case last
    case interim(ScreenRoutable)
}
