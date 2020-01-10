// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class Button: UIButton {
    public let layout: Layout

    required public init(_ layout: Layout = .none) {
        self.layout = layout
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)

        if currentTitle == nil {
            return rect
        }
        switch layout {
        case .none:
            return rect
        case .imageAtTop(let spacing):
            let titleHeight = super.titleRect(forContentRect: contentRect).height
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = ((contentRect.height - (rect.height + spacing + titleHeight)) / 2.0).rounded() + contentEdgeInsets.top
            return rect
        case .imageAtTopmost(let padding):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = contentRect.minY + padding + contentEdgeInsets.top
            return rect
        case .imageAtRight(let spacing):
            let titleWidth = super.titleRect(forContentRect: contentRect).width
            rect.origin.x = rect.minX + titleWidth + (spacing / 2.0).rounded() + contentEdgeInsets.left
            return rect
        case .imageAtRightmost(let padding):
            rect.origin.x = contentRect.width - (rect.width + padding + contentEdgeInsets.right)
            return rect
        }
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)

        if currentImage == nil {
            return rect
        }
        switch layout {
        case .none:
            return rect
        case .imageAtTop(let spacing):
            let imageHeight = super.imageRect(forContentRect: contentRect).height
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = contentRect.height - ((contentRect.height - (imageHeight + spacing + rect.height)) / 2.0).rounded() - (rect.height + contentEdgeInsets.bottom)
            return rect
        case .imageAtTopmost(let padding):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = ((contentRect.height - rect.height) / 2.0).rounded() + contentEdgeInsets.top
            return rect
        case .imageAtRight(let spacing):
            let imageWidth = super.imageRect(forContentRect: contentRect).width
            rect.origin.x = ((contentRect.width - (rect.width + spacing + imageWidth)) / 2.0).rounded() + contentEdgeInsets.left
            return rect
        case .imageAtRightmost:
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            return rect
        }
    }
}

extension Button {
    public enum Layout {
        case none
        case imageAtTop(spacing: CGFloat) /// <note> Spacing equals to the distance between image and title.
        case imageAtTopmost(padding: CGFloat) /// <note> Padding equals to the inset from top for the image while the title is centered.
        case imageAtRight(spacing: CGFloat) /// <note> Spacing equals to the distance between image and title.
        case imageAtRightmost(padding: CGFloat) /// <note> Padding equals to the inset from right for the image while the title is centered.
    }
}
