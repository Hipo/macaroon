// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class Button:
    UIButton,
    BorderDrawable,
    CornerDrawable,
    ShadowDrawable {
    open override var intrinsicContentSize: CGSize {
        if currentImage == nil && currentTitle == nil {
            return .zero
        }

        let superIntrinsicContentSize = super.intrinsicContentSize

        if layout.isHorizontal {
            return superIntrinsicContentSize
        }

        if bounds.isEmpty {
            return superIntrinsicContentSize
        }

        var rect =
            super.contentRect(
                forBounds: bounds
            )
        let iRect = super.imageRect(
            forContentRect: rect
        )
        let tRect = super.titleRect(
            forContentRect: rect
        )

        switch layout {
        case .imageAtTop(let spacing):
            let width = max(iRect.width, tRect.width) + contentEdgeInsets.x
            let height = iRect.height + tRect.height + spacing + contentEdgeInsets.y
            return CGSize(width: width, height: height)
        case .imageAtTopmost(let padding, let titleAdjustmentY):
            let width = max(iRect.width, tRect.width) + contentEdgeInsets.x
            let height =
                iRect.height + tRect.height + padding + contentEdgeInsets.y + titleAdjustmentY
            return CGSize(width: width, height: height)
        case .titleAtBottommost(let padding, let imageAdjustmentY):
            let width = max(iRect.width, tRect.width) + contentEdgeInsets.x
            let height =
                iRect.height + tRect.height + padding + contentEdgeInsets.y - imageAdjustmentY
            return CGSize(width: width, height: height)
        default: return superIntrinsicContentSize
        }
    }

    public var shadow: Shadow?

    public private(set) lazy var shadowLayer = CAShapeLayer()

    public let layout: Layout

    public init(_ layout: Layout = .none) {
        self.layout = layout

        super.init(frame: .zero)

        /// <note>
        /// The content width will be set as the title width, so if the title is short to fill the
        /// width, then it will be centered, which is what the caller expects.
        if layout.isVertical {
            titleLabel?.textAlignment = .center
        }
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func preferredUserInterfaceStyleDidChange() {
        drawAppearance(
            shadow: shadow
        )
    }

    open func preferredContentSizeCategoryDidChange() {}

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
        case .imageAtTopmost(let padding, _):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = contentRect.minY + padding + contentEdgeInsets.top
            return rect
        case .imageAtLeft(let spacing):
            rect.origin.x = rect.origin.x - (spacing / 2.0).rounded()
            return rect
        case .imageAtLeftmost(let padding, _):
            rect.origin.x = contentRect.width - (padding + contentEdgeInsets.left)
            return rect
        case .imageAtRight(let spacing):
            let titleWidth = super.titleRect(forContentRect: contentRect).width
            rect.origin.x = rect.minX + titleWidth + (spacing / 2.0).rounded() + contentEdgeInsets.left
            return rect
        case .imageAtRightmost(let padding, _):
            rect.origin.x = contentRect.width - (rect.width + padding + contentEdgeInsets.right)
            return rect
        case .titleAtBottommost(_, let imageAdjustmentY):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = ((contentRect.height - rect.height) / 2.0).rounded() + imageAdjustmentY + contentEdgeInsets.top
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
            rect.origin.x = contentEdgeInsets.left
            rect.origin.y = contentRect.height - ((contentRect.height - (imageHeight + spacing + rect.height)) / 2.0).rounded() - (rect.height + contentEdgeInsets.bottom)
            rect.size.width = contentRect.width - contentEdgeInsets.x
            return rect
        case .imageAtTopmost(_, let titleAdjustmentY):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = ((contentRect.height - rect.height) / 2.0).rounded() + titleAdjustmentY + contentEdgeInsets.top
            rect.size.width = contentRect.width - contentEdgeInsets.x
            return rect
        case .imageAtLeft(let spacing):
            rect.origin.x = rect.origin.x + (spacing / 2.0).rounded()
            return rect
        case .imageAtLeftmost(_, let titleAdjustmentX):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + titleAdjustmentX + contentEdgeInsets.left
            return rect
        case .imageAtRight(let spacing):
            let imageWidth = super.imageRect(forContentRect: contentRect).width
            rect.origin.x = ((contentRect.width - (rect.width + spacing + imageWidth)) / 2.0).rounded() + contentEdgeInsets.left
            return rect
        case .imageAtRightmost(_, let titleAdjustmentX):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + titleAdjustmentX + contentEdgeInsets.left
            return rect
        case .titleAtBottommost(let padding, _):
            rect.origin.x = ((contentRect.width - rect.width) / 2.0).rounded() + contentEdgeInsets.left
            rect.origin.y = contentRect.maxY - (rect.height + padding + contentEdgeInsets.bottom)
            rect.size.width = contentRect.width - contentEdgeInsets.x
            return rect
        }
    }

    open override func point(
        inside point: CGPoint,
        with event: UIEvent?
    ) -> Bool {
        let leastTouchMagnitude = CGSize.leastTouchMagnitude

        if bounds.size > leastTouchMagnitude {
            return bounds.contains(
                point
            )
        }

        let touchBounds =
            bounds.insetBy(
                dx: min(0, (bounds.width - leastTouchMagnitude.width) / 2),
                dy: min(0, (bounds.height - leastTouchMagnitude.height) / 2)
            )
        return touchBounds.contains(
            point
        )
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let shadow = shadow else {
            return
        }

        updateOnLayoutSubviews(
            shadow: shadow
        )
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                preferredUserInterfaceStyleDidChange()
            }
        }
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            preferredContentSizeCategoryDidChange()
        }
    }
}

extension Button {
    public enum Layout {
        case none
        case imageAtTop(spacing: CGFloat) /// <note> Spacing equals to the distance between image and title.
        case imageAtTopmost(padding: CGFloat, titleAdjustmentY: CGFloat) /// <note> Padding equals to the inset from top for the image while the title is centered.
        case imageAtLeft(spacing: CGFloat) /// <note> Spacing equals to the distance between image and title.
        case imageAtLeftmost(padding: CGFloat, titleAdjustmentX: CGFloat) /// <note> Padding equals to the inset from left for the image while the title is centered offset by titleAdjustmentX.
        case imageAtRight(spacing: CGFloat) /// <note> Spacing equals to the distance between image and title.
        case imageAtRightmost(padding: CGFloat, titleAdjustmentX: CGFloat) /// <note> Padding equals to the inset from right for the image while the title is centered offset by titleAdjustmentX.
        case titleAtBottommost(padding: CGFloat, imageAdjustmentY: CGFloat)

        public var isHorizontal: Bool {
            switch self {
            case .none,
                 .imageAtLeft,
                 .imageAtLeftmost,
                 .imageAtRight,
                 .imageAtRightmost:
                return true
            default: return false
            }
        }

        public var isVertical: Bool {
            return !isHorizontal
        }
    }
}
