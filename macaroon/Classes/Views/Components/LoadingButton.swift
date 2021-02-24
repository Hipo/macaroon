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
    private var cachedIcon: ImageSet?

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

        guard let normalTitle =
                getTitle(
                    for: .normal
                )
        else {
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
        guard let someImage =
                image(
                    for: .normal
                )
        else {
            cachedIcon = nil
            return
        }

        cachedIcon =
            ImageSet(
                someImage,
                highlighted: image(for: .highlighted),
                selected: image(for: .selected),
                disabled: image(for: .disabled)
            )
    }
}
