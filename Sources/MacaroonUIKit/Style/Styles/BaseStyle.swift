// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol BaseStyle: ExpressibleByArrayLiteral {
    associatedtype Attribute: BaseStyleAttribute

    var backgroundColor: Color? { get }
    var tintColor: Color? { get }

    init(
        attributes: [Attribute]
    )

    func modify(
        _ modifiers: Self...
    ) -> Self
}

extension BaseStyle {
    public init() {
        self.init(attributes: [])
    }

    public init(
        arrayLiteral elements: Attribute...
    ) {
        self.init(attributes: elements)
    }
}

public protocol BaseStyleAttribute {
    static func backgroundColor(_ backgroundColor: Color) -> Self
    static func tintColor(_ tintColor: Color) -> Self
}
