// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils
import SnapKit
import UIKit

open class ToastUIPresentationController {
    public private(set) var presentedView: UIView?

    public unowned let presentingView: UIView

    private lazy var transitionQueue =
        AsyncSerialQueue(name: "toastUIPresentationController.transitionQueue")

    private var scheduledDismissing: DispatchWorkItem?
    
    private var config: ToastUIConfiguration

    private let animationController: ToastUIAnimationControlling
    
    public init(
        config: ToastUIConfiguration,
        presentingView: UIView,
        animationController: ToastUIAnimationControlling
    ) {
        self.config = config
        self.presentingView = presentingView
        self.animationController = animationController
    }

    open func present(
        _ viewToPresent: UIView
    ) {
        becomeFirstResponder()

        let starter = makeStarter(for: viewToPresent)
        transitionQueue.add(starter)
    }

    open func dismiss() {
        cancelScheduledDismissing()

        guard let presentedView = presentedView else {
            return
        }

        let animator = makeDismissingAnimator(forLastPresented: presentedView)
        animator.startAnimation()
    }
}

extension ToastUIPresentationController {
    public func becomeFirstResponder() {
        if let presentedView = presentedView,
           presentedView.isDescendant(of: presentingView) {
            presentingView.bringSubviewToFront(presentedView)
        }
    }

    public func resignFirstResponder() {
        if let presentedView = presentedView,
           presentedView.isDescendant(of: presentingView) {
            presentingView.sendSubviewToBack(presentedView)
        }
    }
}

extension ToastUIPresentationController {
    public func makeStarter(
        for viewToPresent: UIView
    ) -> AsyncTask {
        return AsyncTask {
            [weak self] completionBlock in
            guard let self = self else { return }

            self.cancelScheduledDismissing()
            self.addPresented(viewToPresent)

            let presenter = self.makePresenter(for: viewToPresent)
            self.transitionQueue.add(presenter)

            completionBlock()
        }
    }

    public func makePresenter(
        for viewToPresent: UIView
    ) -> AsyncTask {
        guard let presentedView = presentedView else {
            return makePresenter(forNextPresented: viewToPresent)
        }

        return makePresenter(
            forNextPresented: viewToPresent,
            replacingLastPresented: presentedView
        )
    }

    public func makePresenter(
        forNextPresented nextView: UIView
    ) -> AsyncTask {
        let animator = animationController.makePresentingAnimator(forNextPresented: nextView)
        animator.addCompletion {
            [weak self] _ in
            guard let self = self else { return }

            let duration = self.config.presentationDuration

            self.presentedView = nextView
            self.scheduleDismissing(
                afterDuration: duration,
                forLastPresented: nextView
            )
        }

        return makeAnimatablePresenter(animator)
    }

    public func makePresenter(
        forNextPresented nextView: UIView,
        replacingLastPresented lastView: UIView
    ) -> AsyncTask {
        let animator = animationController.makePresentingAnimator(
            forNextPresented: nextView,
            replacingLastPresented: lastView
        )
        animator.addCompletion {
            [weak self] _ in
            guard let self = self else { return }

            let duration = self.config.presentationDuration

            self.presentedView = nextView
            self.scheduleDismissing(
                afterDuration: duration,
                forLastPresented: nextView
            )
        }

        return makeAnimatablePresenter(animator)
    }

    public func makeDismisser(
        forLastPresented lastView: UIView
    ) -> AsyncTask {
        let animator = makeDismissingAnimator(forLastPresented: lastView)
        animator.pauseAnimation()

        return makeAnimatablePresenter(animator)
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

extension ToastUIPresentationController {
    public func addPresented(
        _ viewToPresent: UIView
    ) {
        presentingView.addSubview(viewToPresent)
        animationController.prepareForAnimation(presented: viewToPresent)
    }
}

extension ToastUIPresentationController {
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

        scheduledDismissing = lastScheduledDismissing
    }

    public func cancelScheduledDismissing() {
        scheduledDismissing?.cancel()
        scheduledDismissing = nil
    }
}

extension ToastUIPresentationController {
    private func makeDismissingAnimator(
        forLastPresented lastView: UIView
    ) -> UIViewPropertyAnimator {
        let animator = animationController.makeDismissingAnimator(forLastPresented: lastView)
        animator.addCompletion {
            [weak self] _ in
            guard let self = self else { return }

            if self.presentedView == lastView {
                self.presentedView = nil
            }
        }
        return animator
    }
}
