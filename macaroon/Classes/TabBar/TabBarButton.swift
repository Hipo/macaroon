// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class TabBarButton: UIControl {
    open override var isEnabled: Bool {
        didSet {
            button.isEnabled = isEnabled
        }
    }
    open override var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
        }
    }

    public let barButtonItem: TabBarButtonItemConvertible

    private lazy var button = Button(.imageAtTop(spacing: barButtonItem.spacingBetweenImageAndTitle))

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

    open func customizeAppearance() {
        button.customizeAppearance(barButtonItem.style)
        button.isUserInteractionEnabled = false
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
    }

    open func prepareLayout() {
        addSubview(button)
        button.snp.makeConstraints { maker in
            maker.width.greaterThanOrEqualTo(44.0).priority(.high)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
            maker.leading.greaterThanOrEqualToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.lessThanOrEqualToSuperview()
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return button.frame.contains(point)
    }
}
