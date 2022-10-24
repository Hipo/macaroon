// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class SegmentedControl: BaseControl {
    public var selectedSegmentIndex: Int = -1 {
        didSet {
            let currentSegmentViews = segmentViews
            currentSegmentViews[safe: oldValue]?.isSelected = false
            currentSegmentViews[safe: selectedSegmentIndex]?.isSelected = true
        }
    }

    private var segmentViews: [UIControl] {
        return contentView.arrangedSubviews as? [Button] ?? []
    }

    private lazy var contentView = HStackView()
    private lazy var backgroundView = UIImageView()

    private let theme: SegmentedControlTheme

    public init(_ theme: SegmentedControlTheme) {
        self.theme = theme
        super.init(frame: .zero)

        addUI(theme)
    }
}

extension SegmentedControl {
    public func add(segment: Segment) {
        addDividerIfNeeded()

        let view = segment.makeView()

        contentView.addArrangedSubview(view)
        view.fitToIntrinsicSize()

        view.addTouch(
            target: self,
            action: #selector(notifyWhenSelectedSegmentButtonChanged(_:))
        )
    }

    public func add(segments: [Segment]) {
        segments.forEach(add(segment:))
    }

    public func remove(segmentAt index: Int) {
        if let view = segmentViews[safe: index] {
            contentView.removeArrangedSubview(view)
        }
    }

    public func removeAllSegments() {
        contentView.deleteAllArrangedSubviews()
        selectedSegmentIndex = -1
    }

    public func setEnabled(_ isEnabled: Bool, forSegmentAt index: Int) {
        let view = segmentViews[safe: index]
        view?.isEnabled = isEnabled
    }
}

extension SegmentedControl {
    private func addUI(_ theme: SegmentedControlTheme) {
        addBackground(theme)
        addContent(theme)
    }

    private func addBackground(_ theme: SegmentedControlTheme) {
        guard let style = theme.background else { return }

        backgroundView.customizeAppearance(style)

        addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.top == 0
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }
    }

    private func addContent(_ theme: SegmentedControlTheme) {
        addSubview(contentView)
        contentView.spacing = theme.spacingBetweenSegments
        contentView.snp.makeConstraints {
            $0.top == 0
            $0.leading == 0
            $0.bottom == 0
            $0.trailing == 0
        }
    }

    private func addDividerIfNeeded() {
        guard let style = theme.divider else { return }
        guard let lastSegmentView = segmentViews.last else { return }

        let view = UIImageView()
        view.customizeAppearance(style)

        contentView.addSubview(view)
        view.fitToIntrinsicSize()
        view.snp.makeConstraints {
            $0.height <= contentView
            $0.centerY == 0
            $0.leading == lastSegmentView.snp.trailing + theme.spacingBetweenSegmentAndDivider
        }
    }
}

extension SegmentedControl {
    @objc
    private func notifyWhenSelectedSegmentButtonChanged(_ sender: Button) {
        if let index = segmentViews.firstIndex(of: sender) {
            selectedSegmentIndex = index
            sendActions(for: .valueChanged)
        }
    }
}
