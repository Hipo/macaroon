// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct Form: ExpressibleByArrayLiteral {
    public var paddings: LayoutPaddings = (0.0, 0.0, 0.0, 0.0)

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
                FormFieldIdentifier
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

public protocol FormFieldIdentifier {
    var rawValue: String { get }
}

extension FormFieldIdentifier {
    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension String: FormFieldIdentifier {
    public var rawValue: String {
        return self
    }
}
