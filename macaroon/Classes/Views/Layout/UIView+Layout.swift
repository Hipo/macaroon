// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

extension UIView {
    var compactSafeAreaInsets: UIEdgeInsets {
        if let window = window {
            return window.safeAreaInsets
        }
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}

extension UIView {
    public func fitToSuperview(insetBy margins: UIEdgeInsets = .zero) {
        snp.makeConstraints { maker in
            fitToSuperview(maker, insetBy: margins)
        }
    }

    public func fitToSuperview(_ maker: ConstraintMaker, insetBy margins: UIEdgeInsets = .zero) {
        if margins.top != UIViewNoConstraintMetric {
            maker.top.equalToSuperview().inset(margins.top)
        }
        if margins.left != UIViewNoConstraintMetric {
            maker.leading.equalToSuperview().inset(margins.left)
        }
        if margins.bottom != UIViewNoConstraintMetric {
            maker.bottom.equalToSuperview().inset(margins.bottom)
        }
        if margins.right != UIViewNoConstraintMetric {
            maker.right.equalToSuperview().inset(margins.right)
        }
    }

    public func centerInSuperView(offsetBy offset: CGPoint = CGPoint(x: UIViewNoConstraintMetric, y: UIViewNoConstraintMetric)) {
        snp.makeConstraints { maker in
            centerInSuperView(maker, offsetBy: offset)
        }
    }

    public func centerInSuperView(_ maker: ConstraintMaker, offsetBy offset: CGPoint = CGPoint(x: UIViewNoConstraintMetric, y: UIViewNoConstraintMetric)) {
        maker.centerX.equalToSuperview().offset(offset.x == UIViewNoConstraintMetric ? 0.0 : offset.x)
        maker.centerY.equalToSuperview().offset(offset.y == UIViewNoConstraintMetric ? 0.0 : offset.y)
    }

    public func centerHorizontallyInSuperView(offsetBy offsetX: CGFloat = 0.0, insetBy verticalMargins: (top: CGFloat, bottom: CGFloat) = (UIViewNoConstraintMetric, UIViewNoConstraintMetric)) {
        snp.makeConstraints { maker in
            centerHorizontallyInSuperView(maker, offsetBy: offsetX, insetBy: verticalMargins)
        }
    }

    public func centerHorizontallyInSuperView(_ maker: ConstraintMaker, offsetBy offsetX: CGFloat = 0.0, insetBy verticalMargins: (top: CGFloat, bottom: CGFloat) = (UIViewNoConstraintMetric, UIViewNoConstraintMetric)) {
        maker.centerX.equalToSuperview().offset(offsetX == UIViewNoConstraintMetric ? 0.0 : offsetX)

        if verticalMargins.top != UIViewNoConstraintMetric {
            maker.top.equalToSuperview().inset(verticalMargins.top)
        }
        if verticalMargins.bottom != UIViewNoConstraintMetric {
            maker.bottom.equalToSuperview().inset(verticalMargins.bottom)
        }
    }

    public func centerVerticallyInSuperView(offsetBy offsetY: CGFloat = 0.0, insetBy horizontalMargins: (left: CGFloat, right: CGFloat) = (UIViewNoConstraintMetric, UIViewNoConstraintMetric)) {
        snp.makeConstraints { maker in
            centerVerticallyInSuperView(maker, offsetBy: offsetY, insetBy: horizontalMargins)
        }
    }

    public func centerVerticallyInSuperView(_ maker: ConstraintMaker, offsetBy offsetY: CGFloat = 0.0, insetBy horizontalMargins: (left: CGFloat, right: CGFloat) = (UIViewNoConstraintMetric, UIViewNoConstraintMetric)) {
        maker.centerY.equalToSuperview().offset(offsetY == UIViewNoConstraintMetric ? 0.0 : offsetY)

        if horizontalMargins.left != UIViewNoConstraintMetric {
            maker.leading.equalToSuperview().inset(horizontalMargins.left)
        }
        if horizontalMargins.right != UIViewNoConstraintMetric {
            maker.bottom.equalToSuperview().inset(horizontalMargins.right)
        }
    }
}
