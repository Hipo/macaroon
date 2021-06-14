// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class TabBarButton: BaseControl {
    open override var isEnabled: Bool {
        didSet {
            contentView.isEnabled = isEnabled
            contentView.invalidateIntrinsicContentSize()
        }
    }
    open override var isSelected: Bool {
        didSet {
            contentView.isSelected = isSelected
            contentView.invalidateIntrinsicContentSize()
        }
    }

    public var badge: String? {
        get { badgeView.currentTitle }
        set {
            set(
                badge: newValue,
                animated: true
            )
        }
    }

    public let barButtonItem: TabBarButtonItem

    private lazy var contentView =
        Button(.imageAtTop(spacing: barButtonItem.spacingBetweenIconAndTitle))
    private lazy var badgeView = Button()

    public init(
        _ barButtonItem: TabBarButtonItem
    ) {
        self.barButtonItem = barButtonItem

        super.init(
            frame: .zero
        )

        customizeAppearance()
        prepareLayout()
    }

    open func customizeAppearance() {
        customizeContentAppearance()
        customizeBadgeAppearance()
    }

    open func prepareLayout() {
        addContent()
    }

    open override func hitTest(
        _ point: CGPoint,
        with event: UIEvent?
    ) -> UIView? {
        return contentView.frame.contains(
            point
        ) ? self : nil
    }
}

extension TabBarButton {
    public func set(
        badge: String?,
        animated: Bool
    ) {
        if badge == nil {
            removeBadge(
                animated: animated
            )
            return
        }

        badgeView.setTitle(
            badge,
            for: .normal
        )
        badgeView.invalidateIntrinsicContentSize()

        addBadge(
            animated: animated
        )
    }
}

extension TabBarButton {
    private func customizeContentAppearance() {
        contentView.customizeAppearance(
            barButtonItem.style
        )
        contentView.adjustsImageWhenHighlighted = false
        contentView.isUserInteractionEnabled = false
    }

    private func customizeBadgeAppearance() {
        guard let style = barButtonItem.badgeStyle else {
            return
        }

        badgeView.customizeAppearance(
            style
        )
        badgeView.isUserInteractionEnabled = false
    }
}

extension TabBarButton {
    private func addContent() {
        addSubview(
            contentView
        )
        contentView.snp.makeConstraints {
            $0.greaterThanWidth(
                (44, .defaultHigh)
            )
            $0.centerHorizontally(
                verticalPaddings: (0, 0)
            )
            $0.lessThanHorizontalPaddings(
                (0, 0)
            )
        }
    }

    private func addBadge(
        animated: Bool
    ) {
        if badgeView.isDescendant(
            of: self
        ) {
            return
        }

        addSubview(
            badgeView
        )
        badgeView.contentEdgeInsets = UIEdgeInsets((0, 4, 0, 4))
        badgeView.snp.makeConstraints {
            $0.width >= badgeView.snp.height

            if let imageView = contentView.imageView {
                $0.centerX == imageView.snp.trailing + (barButtonItem.badgePositionAdjustment?.x ?? 0)
                $0.centerY == imageView.snp.top + (barButtonItem.badgePositionAdjustment?.y ?? 0)
            } else {
                $0.leading == contentView.snp.centerX
                $0.bottom == contentView.snp.centerY
            }
        }

        if !animated {
            layoutIfNeeded()
            return
        }

        animateBadge(
            onScreen: true
        )
    }

    private func removeBadge(animated: Bool) {
        let completion: () -> Void = {
            [weak self] in

            self?.badgeView.removeFromSuperview()
        }

        if !animated {
            completion()
            return
        }

        animateBadge(
            onScreen: false,
            completion: completion
        )
    }

    private func animateBadge(
        onScreen: Bool,
        completion: (() -> Void)? = nil
    ) {
        let offScreenTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        if onScreen {
            badgeView.transform = offScreenTransform
            badgeView.layoutIfNeeded()
        }

        let animator =
            UIViewPropertyAnimator(duration: 0.1, dampingRatio: 0.75) {
                [unowned self] in

                self.badgeView.transform = onScreen ? .identity : offScreenTransform
        }
        animator.addCompletion {
            _ in

            completion?()
        }
        animator.startAnimation()
    }
}
