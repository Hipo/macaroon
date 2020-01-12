// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class NavigationBarButton: UIControl {
    open override var isEnabled: Bool {
        didSet {
            button.isEnabled = isEnabled
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            button.isHighlighted = isHighlighted
        }
    }
    open override var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
        }
    }

    public let item: NavigationBarItemConvertible

    private lazy var button = Button(layout)

    private let layout: Button.Layout

    public init(
        _ item: NavigationBarItemConvertible,
        _ layout: Button.Layout = .none
    ) {
        self.item = item
        self.layout = layout
        super.init(frame: .zero)
        customizeAppearance()
        prepareLayout()
        linkInteractors()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func customizeAppearance() {
        button.customizeAppearance(item.style)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
    }

    private func prepareLayout() {
        button.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        switch item.size {
        case .fixed(let size, let alignment):
            button.snp.makeConstraints { maker in
                maker.size.equalTo(size)
            }
            switch alignment {
            case .none:
                break
            case .horizontal(let hAlignment):
                button.contentHorizontalAlignment = hAlignment
            case .vertical(let vAlignment):
                button.contentVerticalAlignment = vAlignment
            }
        case .dynamic(let contentEdgeInsets):
            button.contentEdgeInsets = contentEdgeInsets
        }
    }

    private func linkInteractors() {
        button.addTarget(self, action: #selector(notifyInteractor(_:)), for: .touchUpInside)
    }

    @objc
    private func notifyInteractor(_ sender: Any) {
        item.handler()
    }
}
