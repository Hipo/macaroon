// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class LoadingButton: Button {
    open override var tintColor: UIColor! {
        didSet {
            loadingIndicator.tintColor = tintColor
        }
    }

    public var isLoading: Bool {
        return loadingIndicator.isAnimating
    }

    private var cachedTitle: TextSet?
    private var cachedIcon: StateImageGroup = []

    private let loadingIndicator: LoadingIndicator

    public init(
        _ layout: Button.Layout = .none,
        loadingIndicator: LoadingIndicator = UIActivityIndicatorView(style: .preferred)
    ) {
        self.loadingIndicator = loadingIndicator

        super.init(
            layout
        )
    }
}

extension LoadingButton {
    public func startLoading() {
        isUserInteractionEnabled = false

        saveTitles()
        saveIcons()

        customizeBaseAppearance(
            title: nil
        )
        customizeBaseAppearance(
            icon: nil
        )

        addLoading()
        loadingIndicator.startAnimating()
    }

    public func stopLoading() {
        loadingIndicator.stopAnimating()
        removeLoading()

        customizeBaseAppearance(
            title: cachedTitle
        )
        customizeBaseAppearance(
            icon: cachedIcon
        )

        isUserInteractionEnabled = true
    }
}

extension LoadingButton {
    private func addLoading() {
        addSubview(
            loadingIndicator
        )
        loadingIndicator.snp.makeConstraints {
            $0.center()
        }
    }

    private func removeLoading() {
        loadingIndicator.removeFromSuperview()
    }
}

extension LoadingButton {
    private func saveTitles() {
        func getTitle(
            for state: UIControl.State
        ) -> Text? {
            if let someTitle =
                title(
                    for: state
                ) {
                return someTitle
            }

            return attributedTitle(
                for: state
            )
        }

        let someNormalTitle =
            getTitle(
                for: .normal
            )

        guard let normalTitle = someNormalTitle else {
            cachedTitle = nil
            return
        }

        let highlightedTitle =
            getTitle(
                for: .highlighted
            )
        let selectedTitle =
            getTitle(
                for: .selected
            )
        let disableTitle =
            getTitle(
                for: .disabled
            )

        cachedTitle =
            TextSet(
                normalTitle,
                highlighted: highlightedTitle,
                selected: selectedTitle,
                disabled: disableTitle
            )
    }

    private func saveIcons() {
        var cachedIcon: StateImageGroup = []

        if let normalImage = image(for: .normal) {
            cachedIcon.append(.normal(normalImage))
        }

        if let highlightedImage = image(for: .highlighted) {
            cachedIcon.append(.highlighted(highlightedImage))
        }

        if let selectedImage = image(for: .selected) {
            cachedIcon.append(.highlighted(selectedImage))
        }

        if let disabledImage = image(for: .disabled) {
            cachedIcon.append(.disabled(disabledImage))
        }

        self.cachedIcon = cachedIcon
    }
}
