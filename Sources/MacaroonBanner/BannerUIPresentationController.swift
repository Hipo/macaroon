// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils
import SnapKit
import UIKit

open class BannerUIPresentationController {
    public private(set) lazy var contentView = VStackView()

    public unowned let presentingView: UIView

    private lazy var transitionQueue =
    AsyncSerialQueue(name: "bannerUIPresentationController.transitionQueue")

    public var presentingBanners: [UIView] {
        return contentView.arrangedSubviews
    }

    private var config: BannerUIConfiguration

    private let animationController: BannerUIAnimationControlling

    private var contentShowConstraints: [Constraint] = []
    private var contentHideConstraints: [Constraint] = []

    private var isActive = false

    public init(
        config: BannerUIConfiguration,
        presentingView: UIView,
        animationController: BannerUIAnimationControlling
    ) {
        self.config = config
        self.presentingView = presentingView
        self.animationController = animationController
    }

    open func activate() {
        if isActive {
            return
        }

        addContent()
        hideContent(animated: false)

        isActive = true
    }

    open func deactivate() {
        if !isActive {
            return
        }

        dismissAll(animated: true) {
            [weak self] in
            guard let self = self else {
                return
            }

            self.removeContent()
            self.isActive = false
        }
    }

    open func present(
        _ viewToPresent: UIView
    ) {
        let starter = makeStarter(for: viewToPresent)
        transitionQueue.add(starter)
    }

    open func dismissAll(
        animated: Bool = true
    ) {
        dismissAll(
            animated: animated,
            completion: nil
        )
    }
}

extension BannerUIPresentationController {
    private func addContent() {
        if contentView.isDescendant(of: presentingView) {
            return
        }

        presentingView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.setHorizontalPaddings(config.contentHorizontalEdgeInsets)
        }
        contentView.spacing = config.contentStackSpacing

        contentShowConstraints =
        contentView.snp.prepareConstraints {
            $0.top == config.contentTopPadding
        }
        contentHideConstraints =
        contentView.snp.prepareConstraints {
            $0.bottom == presentingView.snp.top
        }
    }

    private func removeContent() {
        contentShowConstraints = []
        contentHideConstraints = []

        contentView.removeFromSuperview()
    }

    private func showContent(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        contentHideConstraints.deactivate()
        contentShowConstraints.activate()

        if !animated {
            presentingView.layoutIfNeeded()
            return
        }

        animateContentLayout(completion: completion)
    }

    private func hideContent(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        contentShowConstraints.deactivate()
        contentHideConstraints.activate()
        
        if !animated {
            presentingView.layoutIfNeeded()
            return
        }

        animateContentLayout(completion: completion)
    }

    private func animateContentLayout(
        completion: (() -> Void)?
    ) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                [unowned self] in
                self.presentingView.layoutIfNeeded()
            },
            completion: {
                _ in
                completion?()
            }
        )
    }
}

extension BannerUIPresentationController {
    public func makeStarter(
        for viewToPresent: UIView
    ) -> AsyncTask {
        return AsyncTask {
            [weak self] completionBlock in
            guard let self = self else { return }

            self.addPresented(viewToPresent)

            let presenter = self.makePresenter(forNextPresented: viewToPresent)
            self.transitionQueue.add(presenter)

            completionBlock()
        }
    }

    public func makePresenter(
        forNextPresented nextView: UIView
    ) -> AsyncTask {
        if presentingBanners.count > 1 {
            let animator = animationController.makePresentingAnimator(forNextPresented: nextView)
            animator.addCompletion {
                [weak self] _ in
                guard let self = self else { return }

                let duration = self.config.presentationDuration

                self.scheduleDismissing(
                    afterDuration: duration,
                    forLastPresented: nextView
                )
            }

            return makeAnimatablePresenter(animator)
        }

        return AsyncTask {
            [weak self] completionBlock in
            guard let self = self else { return }

            self.showContent(animated: true) {
                let duration = self.config.presentationDuration

                self.scheduleDismissing(
                    afterDuration: duration,
                    forLastPresented: nextView
                )
            }

            completionBlock()
        }
    }

    public func makeDismisser(
        forLastPresented lastView: UIView
    ) -> AsyncTask {
        if presentingBanners.count > 1 {
            let animator = makeDismissingAnimator(forLastPresented: lastView)
            animator.pauseAnimation()

            return makeAnimatablePresenter(animator)
        }

        return AsyncTask {
            [weak self] completionBlock in
            guard let self = self else { return }

            self.hideContent(
                animated: true
            ) {
                self.contentView.deleteArrangedSubview(lastView)
            }

            completionBlock()
        }
    }

    public func makeAnimatablePresenter(
        _ animator: UIViewPropertyAnimator
    ) -> AsyncTask {
        return AsyncTask(
            execution: {
                completionBlock in

                animator.addCompletion {
                    _ in
                    completionBlock()
                }
                animator.startAnimation()
            },
            cancellation: {
                animator.pauseAnimation()
            }
        )
    }
}

extension BannerUIPresentationController {
    public func addPresented(
        _ viewToPresent: UIView
    ) {
        presentingView.bringSubviewToFront(contentView)
        contentView.addArrangedSubview(viewToPresent)
        contentView.layoutIfNeeded()
    }
}

extension BannerUIPresentationController {
    public func scheduleDismissing(
        afterDuration duration: TimeInterval,
        forLastPresented lastView: UIView
    ) {
        let lastScheduledDismissing = DispatchWorkItem(qos: .userInteractive) {
            [weak self] in
            guard let self = self else { return }

            let dismisser = self.makeDismisser(forLastPresented: lastView)
            self.transitionQueue.add(dismisser)
        }

        asyncMain(
            afterDuration: duration,
            workItem: lastScheduledDismissing
        )
    }
}

extension BannerUIPresentationController {
    private func dismissAll(
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let task = AsyncTask {
            [weak self] completionBlock in
            guard let self = self else { return }

            self.hideContent(animated: true) {
                [weak self] in

                guard let self = self else {
                    return
                }

                self.contentView.deleteAllArrangedSubviews()
            }

            completionBlock()
        }

        transitionQueue.add(task)
    }
}

extension BannerUIPresentationController {
    private func makeDismissingAnimator(
        forLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator {
        let animator = animationController.makeDismissingAnimator(forLastPresented: lastView)
        animator.addCompletion {
            [weak self] _ in
            guard let self = self else { return }

            self.contentView.deleteArrangedSubview(lastView)
        }
        return animator
    }
}
