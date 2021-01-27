// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Color {
    var origin: UIColor { get }
    var highlighted: UIColor? { get }
    var selected: UIColor? { get }
    var disabled: UIColor? { get }
}

extension Color {
    public var highlighted: UIColor? {
        return nil
    }
    public var selected: UIColor? {
        return nil
    }
    public var disabled: UIColor? {
        return nil
    }
}

extension UIColor: Color {
    public var origin: UIColor {
        return self
    }
}

public struct ColorSet: Color {
    public let origin: UIColor
    public let highlighted: UIColor?
    public let selected: UIColor?
    public let disabled: UIColor?

    public init(
        _ origin: UIColor,
        highlighted: UIColor? = nil,
        selected: UIColor? = nil,
        disabled: UIColor? = nil
    ) {
        self.origin = origin
        self.highlighted = highlighted
        self.selected = selected
        self.disabled = disabled
    }
}
