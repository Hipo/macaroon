// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public class SegmentedControl: BaseControl {
    public var spacingBetweenSegments: CGFloat = 1.0 {
        didSet {
            contentView.spacing = spacingBetweenSegments
        }
    }
    public var selectedSegmentIndex: Int = -1 {
        didSet {
            segmentButtons[safe: oldValue]?.isSelected = false
            segmentButtons[safe: selectedSegmentIndex]?.isSelected = true
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30.0)
    }

    private var segmentButtons: [Button] {
        return contentView.arrangedSubviews as? [Button] ?? []
    }

    private lazy var contentView = UIStackView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLayout()
    }

    private func prepareLayout() {
        addContent()
    }

    @objc
    private func notifyWhenSelectedSegmentButtonChanged(_ sender: Button) {
        if let index = segmentButtons.firstIndex(of: sender) {
            selectedSegmentIndex = index
            sendActions(for: .valueChanged)
        }
    }
}

extension SegmentedControl {
    private func addContent() {
        addSubview(contentView)
        contentView.axis = .horizontal
        contentView.distribution = .fillEqually
        contentView.alignment = .fill
        contentView.spacing = spacingBetweenSegments
        contentView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }

    private func addSegmentButton(_ segment: SegmentConvertible) -> Button {
        let button = Button(segment.layout)
        button.adjustsImageWhenHighlighted = false
        button.customizeAppearance(segment.style)
        button.setBackgroundImage(segment.style.background?.selected, for: [.selected, .highlighted])
        button.setImage(segment.style.icon?.selected, for: [.selected, .highlighted])
        button.setTitleColor(segment.style.textColor?.selected, for: [.selected, .highlighted])
        button.setEditTitle(segment.style.title?.selected, for: [.selected, .highlighted])
        contentView.addArrangedSubview(button)
        return button
    }
}

extension SegmentedControl {
    public func reload(_ segments: SegmentConvertible...) {
        reload(segments)
    }

    public func reload(_ segments: [SegmentConvertible]?) {
        contentView.deleteAllArrangedSubviews()

        segments?.forEach {
            let segmentButton = self.addSegmentButton($0)
            segmentButton.addTarget(
                self,
                action: #selector(notifyWhenSelectedSegmentButtonChanged(_:)),
                for: .touchUpInside
            )
        }
    }

    public func disable(segmentAt index: Int) {
        segmentButtons[safe: index]?.isEnabled = false
    }
}

public protocol SegmentConvertible {
    var identifier: String { get } /// <warning> No internal checking so it is up to the application to set a unique name.
    var layout: Button.Layout { get }
    var style: ButtonStyling { get }
}

extension SegmentConvertible {
    public var layout: Button.Layout {
        return .none
    }
}
