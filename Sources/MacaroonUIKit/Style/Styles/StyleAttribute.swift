// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol StyleAttribute: Identifiable {
    associatedtype AnyView: UIView

    func apply(
        to view: AnyView
    )
}

extension StyleAttribute {
    public var id: String {
        return String(describing: Self.self)
    }
}

public struct AnyStyleAttribute<
    AnyView: UIView
>: StyleAttribute {
    public var id: String

    private var _apply: (AnyView) -> Void

    init<T: StyleAttribute>(
        _ styleAttribute: T
    ) where T.AnyView == AnyView {
        self.id = styleAttribute.id
        self._apply = styleAttribute.apply
    }

    public func apply(
        to view: AnyView
    ) {
        _apply(view)
    }
}
