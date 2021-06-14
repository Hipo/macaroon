// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import UIKit

open class TabBar: BaseView {
    open override var intrinsicContentSize: CGSize {
        return CGSize((UIView.noIntrinsicMetric, 48.0 + compactSafeAreaInsets.bottom))
    }

    public var items: [TabBarItem] = [] {
        didSet { updateLayoutWhenItemsDidChange() }
    }
    public var selectedIndex: Int? {
        didSet { updateLayoutWhenSelectedIndexDidChange() }
    }
    public var barButtonDidSelect: ((Int) -> Void)?

    public private(set) var barButtons: [TabBarButton] = []

    private lazy var contentView = HStackView()

    private var selectedBarButton: TabBarButton?

    public override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )

        prepareLayout()
    }

    open func prepareLayout() {
        addContent()
    }

    open func updateLayoutWhenItemsDidChange() {
        removeBarButtons()
        addBarButtons()

        barButtons = contentView.arrangedSubviews as! [TabBarButton]
    }

    open func updateLayoutWhenSelectedIndexDidChange() {
        selectedBarButton?.isSelected = false
        selectedBarButton = barButtons[safe: selectedIndex]
        selectedBarButton?.isSelected = true
    }
}

extension TabBar {
    public func set(
        badge: String?,
        forBarButtonAt index: Int,
        animated: Bool
    ) {
        guard let barButton = barButtons[safe: index] else {
            return
        }

        barButton.set(
            badge: badge,
            animated: animated
        )
    }
}

extension TabBar {
    private func addContent() {
        addSubview(
            contentView
        )
        contentView.snp.makeConstraints {
            $0.setPaddings(
                (0, 0, .noMetric, 0)
            )
            $0.setBottomPadding(
                0,
                inSafeAreaOf: self
            )
        }
    }

    private func addBarButtons() {
        var siblingBarButton: TabBarButton?

        items.forEach { item in
            let barButtonItem = item.barButtonItem
            let barButton = TabBarButton(barButtonItem)

            contentView.addArrangedSubview(
                barButton
            )
            barButton.snp.makeConstraints {
                if !item.width.isNoMetric {
                    $0.fitToWidth(
                        item.width
                    )
                } else if let siblingBarButton = siblingBarButton {
                    $0.matchToWidth(
                        of: siblingBarButton
                    )
                } else {
                    siblingBarButton = barButton
                }
            }

            if item.isSelectable {
                barButton.addTouch(
                    target: self,
                    action: #selector(notifyWhenBarButtonWasSelected(_:))
                )
            }
        }
    }

    private func removeBarButtons() {
        contentView.deleteAllArrangedSubviews()
    }
}

extension TabBar {
    @objc
    private func notifyWhenBarButtonWasSelected(
        _ sender: TabBarButton
    ) {
        guard let index = barButtons.firstIndex(of: sender) else {
            return
        }

        barButtonDidSelect?(index)
    }
}
