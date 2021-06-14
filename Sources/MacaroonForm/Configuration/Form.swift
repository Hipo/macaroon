// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

public struct Form: ExpressibleByArrayLiteral {
    public var contentInset: LayoutPaddings = (0, 0, 0, 0)

    public let elements: [Element]

    public init(
        elements: [Element]
    ) {
        self.elements = elements
    }

    public init(
        arrayLiteral elements: Element...
    ) {
        self.init(elements: elements)
    }
}

extension Form {
    public enum Element {
        case field(
                FormField
             )
        case hGroup(
                [(subelement: Self, proportion: CGFloat)] /// <note> 0 < wProportion < 1
             ) /// <note> Horizontal Group
        case vGroup(
                [(subelement: Self, proportion: CGFloat)] /// <note> 0 < hProportion < 1
             ) /// <note> Vertical Group
        case fixedSpace(
                CGFloat
             )
        case separator(
                Separator,
                margin: CGFloat = 8.0
             )
    }
}

public protocol FormField {
    var rawValue: String { get }
}

extension FormField {
    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension String: FormField {
    public var rawValue: String {
        return self
    }
}
