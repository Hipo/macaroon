// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct Shadow {
    public var isRounded: Bool {
        return
            !cornerRadii.isEmpty &&
            !corners.isEmpty
    }

    public let color: UIColor
    public let opacity: Float
    public let offset: CGSize
    public let radius: CGFloat
    public let fillColor: UIColor?
    public let cornerRadii: CGSize
    public let corners: UIRectCorner

    public init(
        color: UIColor,
        opacity: Float,
        offset: LayoutSize,
        radius: CGFloat,
        fillColor: UIColor?,
        cornerRadii: LayoutSize = (0, 0),
        corners: UIRectCorner = []
    ) {
        self.color = color
        self.opacity = opacity
        self.offset = CGSize(offset)
        self.radius = radius
        self.fillColor = fillColor
        self.cornerRadii = CGSize(cornerRadii)
        self.corners = corners
    }
}
