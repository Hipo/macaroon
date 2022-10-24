// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Segment {
    typealias Style = ButtonStyle
    typealias Layout = Button.Layout

    var layout: Layout { get }
    var style: Style { get }
    var contentEdgeInsets: UIEdgeInsets { get }
}

extension Segment {
    func makeView() -> UIControl {
        let view = Button(layout)
        view.adjustsImageWhenHighlighted = false
        view.contentEdgeInsets = contentEdgeInsets
        view.customizeAppearance(style)
        return view
    }
}
