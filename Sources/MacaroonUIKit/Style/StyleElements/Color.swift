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

public protocol StateColor:
    Color,
    Hashable {
    typealias State = UIControl.State

    var state: State { get }
}

extension StateColor {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(state.rawValue)
    }
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
}

extension AnyStateColor {
    public static func normal(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(
            NormalColor(color: color)
        )
    }

    public static func highlighted(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(
            HighlightedColor(color: color)
        )
    }

    public static func selected(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(
            SelectedColor(color: color)
        )
    }

    public static func disabled(
        _ color: Color
    ) -> AnyStateColor {
        return AnyStateColor(
            DisabledColor(color: color)
        )
    }
}

public struct NormalColor: StateColor {
    public let uiColor: UIColor
    public var state: State = .normal

    public init(
        color: Color
    ) {
        self.uiColor = color.uiColor
    }
}

public struct HighlightedColor: StateColor {
    public let uiColor: UIColor
    public var state: State = .highlighted

    public init(
        color: Color
    ) {
        self.uiColor = color.uiColor
    }
}

public struct SelectedColor: StateColor {
    public let uiColor: UIColor
    public var state: State = .selected

    public init(
        color: Color
    ) {
        self.uiColor = color.uiColor
    }
}

public struct DisabledColor: StateColor {
    public let uiColor: UIColor
    public var state: State = .disabled

    public init(
        color: Color
    ) {
        self.uiColor = color.uiColor
    }
}

public typealias ColorGroup = Set<AnyStateColor>

extension ColorGroup {
    public subscript (
        state: AnyStateImage.State
    ) -> UIColor? {
        return first { $0.state == state }?.uiColor
    }
}
