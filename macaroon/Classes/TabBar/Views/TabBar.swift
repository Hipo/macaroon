// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBar: View, TabBarPresentable {
    public var barButtonItems: [TabBarButtonItemConvertible] = [] {
        didSet {
            updateLayoutWhenBarButtonItemsChanged()
        }
    }
    public var selectedBarButtonIndex: Int? {
        didSet {
            updateLayoutWhenSelectedBarButtonItemChanged()
        }
    }
    public var barButtonDidSelect: ((Int) -> Void)?

    public lazy var container = UIStackView()

    public var barButtons: [TabBarButton] {
        return container.arrangedSubviews as? [TabBarButton] ?? []
    }

    private var selectedBarButton: TabBarButton?

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44.0 + compactSafeAreaInsets.bottom)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    open func customizeAppearance(_ styleGuide: TabBarStyleGuideConvertible) {
        customizeBaseAppearance(styleGuide)
    }

    open func prepareLayout() {
        addContainer()
    }

    open func updateLayoutWhenBarButtonItemsChanged() {
        removeBarButtons()
        addBarButtons()
    }

    open func updateLayoutWhenSelectedBarButtonItemChanged() {
        selectedBarButton?.isSelected = false
        selectedBarButton = barButtons[safe: selectedBarButtonIndex]
        selectedBarButton?.isSelected = true
    }

    @objc
    private func notifyWhenBarButtonSelected(_ sender: TabBarButton) {
        if let index = barButtons.firstIndex(of: sender) {
            barButtonDidSelect?(index)
        }
    }
}

extension TabBar {
    private func addContainer() {
        addSubview(container)
        container.axis = .horizontal
        container.alignment = .fill
        container.distribution = .fill
        container.spacing = 0.0
        container.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalTo(safeAreaLayoutGuide)
            maker.trailing.equalToSuperview()
        }
    }

    private func addBarButtons() {
        var referenceAutosizedBarButton: TabBarButton?

        barButtonItems.forEach { barButtonItem in
            let barButton = TabBarButton(barButtonItem)

            container.addArrangedSubview(barButton)
            barButton.snp.makeConstraints { maker in
                if barButtonItem.width.isIntrinsicMetric {
                    maker.width.equalTo(barButtonItem.width)
                } else if let reference = referenceAutosizedBarButton {
                    maker.width.equalTo(reference)
                } else {
                    referenceAutosizedBarButton = barButton
                }
            }

            if barButtonItem.isSelectable {
                barButton.addTarget(self, action: #selector(notifyWhenBarButtonSelected(_:)), for: .touchUpInside)
            }
        }
    }

    private func removeBarButtons() {
        container.deleteAllArrangedSubviews()
    }
}
