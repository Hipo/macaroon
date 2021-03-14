// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBarButton: UIControl {
    public var badge: String? {
        get { return badgeView.currentTitle }
        set { set(badge: newValue, animated: true) }
    }

    open override var isEnabled: Bool {
        didSet {
            contentView.isEnabled = isEnabled
        }
    }
    open override var isSelected: Bool {
        didSet {
            contentView.isSelected = isSelected
        }
    }

    public let barButtonItem: TabBarButtonItemConvertible

    private lazy var contentView = Button(.imageAtTop(spacing: barButtonItem.spacingBetweenImageAndTitle))
    private lazy var badgeView = Button()

    public init(_ barButtonItem: TabBarButtonItemConvertible) {
        self.barButtonItem = barButtonItem
        super.init(frame: .zero)
        customizeAppearance()
        prepareLayout()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func customizeAppearance() {
        customizeContentAppearance()
        customizeBadgeAppearance()
    }

    private func prepareLayout() {
        addContent()
    }

    open func set(badge: String?, animated: Bool) {
        if badge == nil {
            removeBadge(animated: animated)
            return
        }
        badgeView.setTitle(badge, for: .normal)
        badgeView.invalidateIntrinsicContentSize()
        addBadge(animated: animated)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if contentView.frame.contains(point) {
            return self
        }
        return nil
    }
}

extension TabBarButton {
    private func customizeContentAppearance() {
        contentView.customizeAppearance(barButtonItem.style)
        contentView.isUserInteractionEnabled = false
        contentView.adjustsImageWhenHighlighted = false
        contentView.titleLabel?.adjustsFontSizeToFitWidth = true
        contentView.titleLabel?.minimumScaleFactor = 0.5
    }

    private func customizeBadgeAppearance() {
        if let style = barButtonItem.badgeStyle {
            badgeView.customizeAppearance(style)
            badgeView.isUserInteractionEnabled = false
        }
    }
}

extension TabBarButton {
    private func addContent() {
        addSubview(contentView)
        contentView.snp.makeConstraints { maker in
            maker.width.greaterThanOrEqualTo(44.0).priority(.high)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
    }

    private func addBadge(animated: Bool) {
        if badgeView.isDescendant(of: self) {
            return
        }

        addSubview(badgeView)
        badgeView.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)
        badgeView.snp.makeConstraints { maker in
            maker.width.greaterThanOrEqualTo(badgeView.snp.height)

            if let imageView = contentView.imageView {
                maker.centerX.equalTo(imageView.snp.trailing).offset(barButtonItem.badgePositionAdjustment?.x ?? 0.0)
                maker.centerY.equalTo(imageView.snp.top).offset(barButtonItem.badgePositionAdjustment?.y ?? 0.0)
            } else {
                maker.leading.equalTo(contentView.snp.centerX)
                maker.bottom.equalTo(contentView.snp.centerY)
            }
        }

        if animated {
            animateBadge(onScreen: true) { _ in }
        }
    }

    private func removeBadge(animated: Bool) {
        if !animated {
            badgeView.removeFromSuperview()
            return
        }
        animateBadge(onScreen: false) { [weak self] _ in
            self?.badgeView.removeFromSuperview()
        }
    }

    private func animateBadge(onScreen: Bool, onCompleted completion: @escaping (UIViewAnimatingPosition) -> Void) {
        let offScreenTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        if onScreen {
            badgeView.transform = offScreenTransform
            badgeView.layoutIfNeeded()
        }
        let animator = UIViewPropertyAnimator(duration: 0.1, dampingRatio: 0.75) {
            self.badgeView.transform = onScreen ? .identity : offScreenTransform
        }
        animator.addCompletion(completion)
        animator.startAnimation()
    }
}
