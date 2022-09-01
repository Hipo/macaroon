// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

public class SegmentedControl: BaseControl {
    public var spacingBetweenSegments: CGFloat {
        get { contentView.spacing }
        set { contentView.spacing = newValue }
    }

    public var selectedSegmentIndex: Int = -1 {
        didSet {
            let currentSegmentButtons = segmentButtons
            currentSegmentButtons[safe: oldValue]?.isSelected = false
            currentSegmentButtons[safe: selectedSegmentIndex]?.isSelected = true
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30.0)
    }

    private var segmentButtons: [Button] {
        return contentView.arrangedSubviews as? [Button] ?? []
    }

    private lazy var contentView = UIStackView()
    private lazy var backgroundImageView = UIImageView()

    public var backgroundImage: UIImage? {
        get { backgroundImageView.image }
        set { backgroundImageView.image = newValue }
    }

    public var separatorImage: UIImage?

    private let distributionMode: UIStackView.Distribution

    public init(distributionMode: UIStackView.Distribution = .fillEqually) {
        self.distributionMode = distributionMode

        super.init(frame: .zero)

        prepareLayout()
    }

    private func prepareLayout() {
        addBackgroundImage()
        addContent()
    }
}

extension SegmentedControl {
    public func add(segment: Segment) {
        let segmentButton = addButton(of: segment)
        segmentButton.addTarget(self, action: #selector(notifyWhenSelectedSegmentButtonChanged(_:)), for: .touchUpInside)
    }

    public func add(segments: [Segment]) {
        segments.forEach(add(segment:))
    }

    public func remove(segmentAt index: Int) {
        if let segmentButton = segmentButtons[safe: index] {
            contentView.removeArrangedSubview(segmentButton)
        }
    }

    public func removeAllSegments() {
        contentView.deleteAllArrangedSubviews()
        selectedSegmentIndex = -1
    }

    public func setEnabled(_ isEnabled: Bool, forSegmentAt index: Int) {
        segmentButtons[safe: index]?.isEnabled = isEnabled
    }
}

extension SegmentedControl {
    private func addBackgroundImage() {
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func addContent() {
        addSubview(contentView)
        contentView.axis = .horizontal
        contentView.distribution = distributionMode
        contentView.alignment = .fill
        contentView.spacing = 0.0
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func addButton(of segment: Segment) -> Button {
        let button = Button(segment.layout)
        button.adjustsImageWhenHighlighted = false
        button.customizeAppearance(segment.style)
        if let contentEdgeInsets = segment.contentEdgeInsets {
            button.contentEdgeInsets = contentEdgeInsets
        }

        addSeparatorIfNeeded()
        contentView.addArrangedSubview(button)
        return button
    }

    private func addSeparatorIfNeeded() {
        if  let separatorImage = separatorImage,
            !contentView.subviews.isEmpty {
            let separatorImageView = UIImageView(image: separatorImage)
            separatorImageView.contentMode = .center
            contentView.addArrangedSubview(separatorImageView)
        }
    }
}

extension SegmentedControl {
    @objc
    private func notifyWhenSelectedSegmentButtonChanged(_ sender: Button) {
        if let index = segmentButtons.firstIndex(of: sender) {
            selectedSegmentIndex = index
            sendActions(for: .valueChanged)
        }
    }
}
