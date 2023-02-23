// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SnapKit
import UIKit

open class BlockingLoadingController {
    public private(set) var isLoading = false

    public private(set) var chromeView: UIView!
    public private(set) var loadingIndicator: LoadingIndicator!

    public unowned let presentingView: UIView

    public var configuration: BlockingLoadingControllerConfiguration
    
    private var currentLoadingLayoutAnimator: UIViewPropertyAnimator?

    private var loadingIndicatorStartConstraints: [Constraint] = []
    private var loadingIndicatorStopConstraints: [Constraint] = []

    public init(
        presentingView: UIView,
        configuration: BlockingLoadingControllerConfiguration =
            BlockingLoadingControllerConfiguration()
    ) {
        self.presentingView = presentingView
        self.configuration = configuration
    }

    open func startLoading() {
        if isLoading {
            return
        }

        isLoading = true

        if let currentLoadingLayoutAnimator = currentLoadingLayoutAnimator,
           currentLoadingLayoutAnimator.isRunning {
            currentLoadingLayoutAnimator.isReversed.toggle()
            return
        }

        prepareLayout()
        chromeView.layoutIfNeeded()
        
        currentLoadingLayoutAnimator = makeLoadingLayoutAnimator(loading: true)
        currentLoadingLayoutAnimator?.addCompletion {
            [weak self] position in
            guard let self = self else { return }
            
            switch position {
            case .start:
                self.removeLayout()
            case .end:
                self.loadingIndicator.startAnimating()
            default:
                break
            }
        }
        currentLoadingLayoutAnimator?.startAnimation()
    }

    open func stopLoading() {
        if !isLoading {
            return
        }

        isLoading = false

        if let currentLoadingLayoutAnimator = currentLoadingLayoutAnimator,
           currentLoadingLayoutAnimator.isRunning {
            currentLoadingLayoutAnimator.isReversed.toggle()
            return
        }
        
        currentLoadingLayoutAnimator = makeLoadingLayoutAnimator(loading: false)
        currentLoadingLayoutAnimator?.addCompletion {
            [weak self] position in
            guard let self = self else { return }
            
            switch position {
            case .start:
                self.updateLoadingIndicatorLayoutWhenLoadingStatusDidChange(loading: true)
            case .end:
                self.loadingIndicator.stopAnimating()
                self.removeLayout()
            default:
                break
            }
        }
        currentLoadingLayoutAnimator?.startAnimation()
    }
}

extension BlockingLoadingController {
    private func makeLoadingLayoutAnimator(
        loading: Bool
    ) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(
            duration: 0.1,
            curve: .easeOut
        ) { [weak self] in
            guard let self = self else { return }
            
            self.updateLayoutWhenLoadingStatusDidChange(loading: loading)
            self.chromeView.layoutIfNeeded()
        }
    }
}

extension BlockingLoadingController {
    private func prepareLayout() {
        addChrome()
        addLoadingIndicator()

        updateLayoutWhenLoadingStatusDidChange(
            loading: false
        )
    }

    private func updateLayoutWhenLoadingStatusDidChange(
        loading: Bool
    ) {
        updateChromeLayoutWhenLoadingStatusDidChange(
            loading: loading
        )
        updateLoadingIndicatorLayoutWhenLoadingStatusDidChange(
            loading: loading
        )
    }

    private func removeLayout() {
        removeLoadingIndicator()
        removeChrome()
    }

    private func addChrome() {
        let view = UIView()
        view.customizeAppearance(
            configuration.chromeStyle
        )

        presentingView.addSubview(
            view
        )
        view.snp.makeConstraints {
            $0.setPaddings()
        }

        chromeView = view
    }

    private func updateChromeLayoutWhenLoadingStatusDidChange(
        loading: Bool
    ) {
        chromeView.alpha = loading ? 1 : 0
    }

    private func removeChrome() {
        chromeView.removeFromSuperview()
        chromeView = nil
    }

    private func addLoadingIndicator() {
        let view = configuration.loadingIndicatorClass.init()

        chromeView.addSubview(
            view
        )
        view.snp.makeConstraints {
            $0.width <= presentingView * configuration.loadingIndicatorMaxWidthRatio

            $0.centerHorizontally()
        }

        loadingIndicatorStartConstraints =
            view.snp.prepareConstraints {
                $0.centerVertically(
                    offset: configuration.loadingIndicatorCenterOffsetY
                )
            }
        loadingIndicatorStopConstraints =
            view.snp.prepareConstraints {
                $0.top == chromeView.snp.bottom
            }

        loadingIndicator = view
    }

    private func updateLoadingIndicatorLayoutWhenLoadingStatusDidChange(
        loading: Bool
    ) {
        if loading {
            loadingIndicatorStopConstraints.deactivate()
            loadingIndicatorStartConstraints.activate()
        } else {
            loadingIndicatorStartConstraints.deactivate()
            loadingIndicatorStopConstraints.activate()
        }
    }

    private func removeLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
        loadingIndicator = nil
    }
}
