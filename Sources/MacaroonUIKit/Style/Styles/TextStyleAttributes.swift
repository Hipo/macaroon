// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils
import UIKit

public protocol TextStyleAttribute: StyleAttribute where AnyView == UILabel {}

public struct TextOverflowTextStyleAttribute: TextStyleAttribute {
    public let textOverflow: TextOverflow

    public init(
        _ textOverflow: TextOverflow
    ) {
        self.textOverflow = textOverflow
    }

    public func apply(
        to view: UILabel
    ) {
        view.numberOfLines = textOverflow.numberOfLines
        view.lineBreakMode = textOverflow.lineBreakMode
        view.adjustsFontSizeToFitWidth = textOverflow.adjustFontSizeToFitWidth
        view.minimumScaleFactor = textOverflow.minimumScaleFactor
    }
}

extension AnyStyleAttribute where AnyView == UILabel {
    public static func textOverflow(
        _ textOverflow: TextOverflow
    ) -> Self {
        return AnyStyleAttribute(
            TextOverflowTextStyleAttribute(textOverflow)
        )
    }
}
