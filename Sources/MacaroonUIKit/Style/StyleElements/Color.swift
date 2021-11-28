// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import UIKit

public protocol Color {
    var uiColor: UIColor { get }
}

extension Color
where
    Self: RawRepresentable,
    Self.RawValue == String {
    public var uiColor: UIColor {
        return rawValue.uiColor
    }
}

extension UIColor: Color {
    public var uiColor: UIColor {
        return self
    }
}

extension String: Color {
    public var uiColor: UIColor {
        return col(self)
    }
}

public protocol StateColor: Color {
    typealias State = UIControl.State

    var state: State { get }
}

public struct AnyStateColor: StateColor {
    public let uiColor: UIColor
    public let state: State

    public init<T: StateColor>(
        _ base: T
    ) {
        self.uiColor = base.uiColor
        self.state = base.state
    }

    public init(
        color: Color,
        state: State
    ) {
        self.uiColor = color.uiColor
        self.state = state
    }
}

extension AnyStateColor {
    public static func normal(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(color: color, state: .normal)
    }

    public static func highlighted(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(color: color, state: .highlighted)
    }

    public static func selected(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(color: color, state: .selected)
    }

    public static func disabled(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(color: color, state: .disabled)
    }
}

public typealias StateColorGroup = [AnyStateColor]

extension StateColorGroup {
    public subscript (
        state: StateColor.State
    ) -> UIColor? {
        return first { $0.state == state }?.uiColor
    }
}
