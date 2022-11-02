// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit
import MacaroonUtils
import UIKit

public class KeyboardController: NotificationObserver {
    private typealias KeyboardExecutable = (execute: (Keyboard) -> Void, animated: Bool)

    public var notificationObservations: [NSObjectProtocol] = []

    public private(set) var keyboard: Keyboard?

    public var isKeyboardVisible: Bool {
        return keyboard != nil
    }

    public unowned let scrollView: UIScrollView
    public unowned let screen: UIViewController & KeyboardControllerDataSource

    private var executableToPerformAlongsideWhenKeyboardIsShowing: KeyboardExecutable?
    private var executableToPerformAlongsideWhenKeyboardIsHiding: KeyboardExecutable?

    private var keyboardAnimator: UIViewPropertyAnimator?

    public init(
        scrollView: UIScrollView,
        screen: UIViewController & KeyboardControllerDataSource
    ) {
        self.scrollView = scrollView
        self.screen = screen
    }
}

extension KeyboardController {
    public func activate() {
        observeShowNotification()
        observeHideNotification()
    }

    public func deactivate() {
        stopObservingNotifications()
        reset()
    }

    public func reset() {
        keyboard = nil
    }
}

extension KeyboardController {
    /// <note>
    /// Return true for `afterContentDidChange` if the scroll content, especially the size, changes.
    public func scrollToEditingRect(
        afterContentDidChange: Bool,
        animated: Bool
    ) {
        guard let keyboard = keyboard else {
            return
        }

        let editingRectBeforeUpdates =
            screen.keyboardController(
                self,
                editingRectIn: scrollView
            )

        /// <note>
        /// Finalize the layout so that the calculations could produce the correct results.
        screen.view.layoutIfNeeded()

        if afterContentDidChange {
            adjustContentInsetWhenKeyboardWillShow(
                keyboard
            )
        }

        let editingRectAfterUpdates =
            screen.keyboardController(
                self,
                editingRectIn: scrollView
            )

        guard let editingRect = editingRectAfterUpdates else {
            return
        }

        let visibleRect = calculateVisibleRectWhenKeyboardIsVisible(keyboard)

        if visibleRect.contains(editingRect) {
            return
        }

        if let rect = editingRectBeforeUpdates {
            let yDeltaAfterUpdates = editingRect.minY - rect.minY

            if yDeltaAfterUpdates != 0 {
                scrollView.setContentOffset(
                    y: scrollView.contentOffset.y + yDeltaAfterUpdates
                )
            }
        }

        let someNewContentOffset =
            calculateContentOffset(
                forScrollingToEditingRect: editingRect,
                inRect: visibleRect
            )

        guard let newContentOffset = someNewContentOffset else {
            return
        }

        scrollView.setContentOffset(
            newContentOffset,
            animated: animated
        )
    }
}

extension KeyboardController {
    public func performAlongsideWhenKeyboardIsShowing(
        animated: Bool,
        execute: @escaping (Keyboard) -> Void
    ) {
        executableToPerformAlongsideWhenKeyboardIsShowing = (execute, animated)
    }

    public func performAlongsideWhenKeyboardIsHiding(
        animated: Bool,
        execute: @escaping (Keyboard) -> Void
    ) {
        executableToPerformAlongsideWhenKeyboardIsHiding = (execute, animated)
    }
}

extension KeyboardController {
    private func observeShowNotification() {
        observeWhenKeyboardWillShow {
            [weak self] notification in

            guard let self = self else {
                return
            }

            if !self.screen.shouldPerformChangesWhenKeyboardDidShow(self) {
                return
            }

            let lastKeyboard = self.keyboard
            let newKeyboard = Keyboard(notification: notification)

            if !newKeyboard.isLocal {
                return
            }

            self.keyboard = newKeyboard

            self.adjustContentInsetWhenKeyboardWillShow(
                newKeyboard
            )

            if lastKeyboard?.height == newKeyboard.height {
                return
            }

            self.scrollToEditingRect(
                alongsideTransitionOf: newKeyboard
            )
        }
    }

    private func observeHideNotification() {
        observeWhenKeyboardWillHide {
            [weak self] notification in

            guard let self = self else {
                return
            }

            if !self.screen.shouldPerformChangesWhenKeyboardDidHide(self) {
                return
            }

            let keyboard = Keyboard(notification: notification)

            if !keyboard.isLocal {
                return
            }

            self.keyboard = nil

            self.adjustContentInsetWhenKeyboardDidHide(
                keyboard
            )

            self.performIfNeeded(
                executable: self.executableToPerformAlongsideWhenKeyboardIsHiding,
                alongsideKeyboardAction: nil,
                for: keyboard
            )
        }
    }
}

extension KeyboardController {
    private func adjustContentInsetWhenKeyboardWillShow(
        _ keyboard: Keyboard
    ) {
        let kbHeight = keyboard.height
        let bottomInsetOverKeyboard =
            screen.bottomInsetOverKeyboardWhenKeyboardDidShow(
                self
            )
        let additionalBottomInsetOverKeyboard =
            screen.additionalBottomInsetOverKeyboardWhenKeyboardDidShow(self)
        let bottomInsetUnderKeyboard =
            screen.bottomInsetUnderKeyboardWhenKeyboardDidShow(
                self
            )
        let bottomInset =
            kbHeight +
            bottomInsetOverKeyboard +
            additionalBottomInsetOverKeyboard -
            bottomInsetUnderKeyboard
        let scrollHeight =
            scrollView.contentSize.height +
            scrollView.contentInset.top +
            bottomInset
        let visibleHeight = calculateVisibleHeightWhenKeyboardIsHidden()

        if visibleHeight >= scrollHeight {
            return
        }

        /// <note>
        /// Because the safe area bottom inset will be automatically added by the system.
        /// `contentInsetAdjustmentBehavior = .automatic`
        scrollView.setContentInset(
            bottom: bottomInset - scrollView.safeAreaInsets.bottom
        )
    }

    private func adjustContentInsetWhenKeyboardDidHide(
        _ keyboard: Keyboard
    ) {
        let bottomInset =
            screen.bottomInsetWhenKeyboardDidHide(
                self
            )
        scrollView.setContentInset(
            bottom: bottomInset
        )
    }
}

extension KeyboardController {
    private func scrollToEditingRect(
        alongsideTransitionOf keyboard: Keyboard
    ) {
        func performExecutableIfNeeded() {
            performIfNeeded(
                executable: executableToPerformAlongsideWhenKeyboardIsShowing,
                alongsideKeyboardAction: nil,
                for: keyboard
            )
        }

        let someEditingRect =
            screen.keyboardController(
                self,
                editingRectIn: scrollView
            )

        guard let editingRect = someEditingRect else {
            performExecutableIfNeeded()
            return
        }

        let visibleRect = calculateVisibleRectWhenKeyboardIsVisible(keyboard)

        if visibleRect.contains(editingRect) {
            performExecutableIfNeeded()
            return
        }

        let someNewContentOffset =
            calculateContentOffset(
                forScrollingToEditingRect: editingRect,
                inRect: visibleRect
            )

        guard let newContentOffset = someNewContentOffset else {
            performExecutableIfNeeded()
            return
        }

        performIfNeeded(
            executable: executableToPerformAlongsideWhenKeyboardIsShowing,
            alongsideKeyboardAction: {
                [unowned self] in

                self.scrollView.contentOffset = newContentOffset
            },
            for: keyboard
        )
    }

    private func calculateVisibleRectWhenKeyboardIsVisible(
        _ keyboard: Keyboard
    ) -> CGRect {
        let bottomInsetUnderKeyboard = screen.bottomInsetUnderKeyboardWhenKeyboardDidShow(self)

        var visibleHeight = calculateVisibleHeightWhenKeyboardIsHidden()
        visibleHeight -= screen.spacingBetweenEditingRectAndKeyboard(self)
        visibleHeight -= screen.bottomInsetOverKeyboardWhenKeyboardDidShow(self)
        visibleHeight -= keyboard.height

        if bottomInsetUnderKeyboard > 0 {
            visibleHeight += bottomInsetUnderKeyboard
            visibleHeight -= scrollView.safeAreaInsets.bottom
        }

        /// <note>
        /// `bounds` indicates the max visible rect in the scrollable area.
        var visibleRect = scrollView.bounds
        visibleRect.origin.y = abs(scrollView.contentOffset.y)

        /// <note>
        /// `scrollView.adjustedContentInset.bottom` indicates how much area the keyboard covers over the
        /// view. It was calculated at the moment when the keyboard is shown first.
        visibleRect.size.height = max(visibleHeight, 0)

        return visibleRect
    }

    private func calculateVisibleHeightWhenKeyboardIsHidden() -> CGFloat {
        /// <note>
        /// Because the scroll view bounds hasn't been finalized yet if the keyboard is shown in
        /// `viewWillAppear(_:)`. Also, The scrollview shouldn't reasonably cover a larger area
        /// than its parent.
        return min(
            scrollView.bounds.height,
            screen.view.bounds.height
        )
    }

    private func calculateContentOffset(
        forScrollingToEditingRect editingRect: CGRect,
        inRect rect: CGRect
    ) -> CGPoint? {
        var contentOffset = scrollView.contentOffset

        if editingRect.height > rect.height {
            /// <note>
            /// Scroll to the end of the editing rect if it has a larger area than the visible rect.
            contentOffset.y += editingRect.maxY - rect.maxY

            return contentOffset
        }

        if editingRect.maxY > rect.maxY {
            /// <note>
            /// The editing rect is below the visible rect.
            contentOffset.y += editingRect.maxY - rect.maxY

            return contentOffset
        }

        if rect.minY > editingRect.minY {
            /// <note>
            /// The editing rect is above the visible rect.
            contentOffset.y -= rect.minY - editingRect.minY

            return contentOffset
        }

        /// <note>
        /// `contentOffset`doesn't change.
        return nil
    }

    private func animateAlongsideTransition(
        of keyboard: Keyboard,
        animations: @escaping () -> Void
    ) {
        discardAnimationsAlongsideKeyboardTransition()

        let animator = UIViewPropertyAnimator(
            duration: keyboard.animationDuration,
            curve: keyboard.animationCurve
        ) {
            animations()
        }
        animator.startAnimation()

        keyboardAnimator = animator
    }

    private func discardAnimationsAlongsideKeyboardTransition() {
        keyboardAnimator?.stopAnimation(false)
        keyboardAnimator?.finishAnimation(at: .current)
        keyboardAnimator = nil
    }
}

extension KeyboardController {
    private func performIfNeeded(
        executable: KeyboardExecutable?,
        alongsideKeyboardAction action: (() -> Void)?,
        for keyboard: Keyboard
    ) {
        guard let executable = executable else {
            guard let action = action else {
                return
            }

            animateAlongsideTransition(
                of: keyboard
            ) {
                action()
            }

            return
        }

        if executable.animated {
            animateAlongsideTransition(
                of: keyboard
            ) {
                action?()
                executable.execute(keyboard)
            }

            return
        }

        /// <warning>
        /// If the executable closure contains `layoutIfNeeded()` function, it seems it is being
        /// animatated during the keyboard is being shown (KeyboardWillShowNotification) even when
        /// it is called outside of the animation block. It doesn't have an issue during the
        /// keyboard is being hidden (KeyboardDidHideNotification).
        executable.execute(keyboard)

        if let action = action {
            animateAlongsideTransition(
                of: keyboard
            ) {
                action()
            }
        }
    }
}

public protocol KeyboardControllerDataSource: AnyObject {
    func shouldPerformChangesWhenKeyboardDidShow(_ keyboardController: KeyboardController) -> Bool

    /// <note>
    /// Returns the editing frame in the visible view. It is up to the dataSource to calculate
    /// the editing frame in the `view` coordinate system.
    func keyboardController(_ keyboardController: KeyboardController, editingRectIn view: UIView) -> CGRect?

    /// <note>
    /// Returns the height of the overlay content which should be over the keyboard.
    func bottomInsetOverKeyboardWhenKeyboardDidShow(_ keyboardController: KeyboardController) -> LayoutMetric

    /// <note>
    /// Returns the additional inset over the overlay content / keyboard. It can be used to increase
    /// the content area which gives the space to scroll the editing view freely to anywhere in the
    /// visible view. It should be coordinated with `spacingBetweenEditingRectAndKeyboard(_:)` in
    /// order to set things up properly.
    func additionalBottomInsetOverKeyboardWhenKeyboardDidShow(_ keyboardController: KeyboardController) -> LayoutMetric

    /// <note>
    /// Returns the inset of the scroll view to the bottom edge of the screen, which also places the
    /// under the keyboard, i.e. tab bar etc. Include the safe area.
    func bottomInsetUnderKeyboardWhenKeyboardDidShow(_ keyboardController: KeyboardController) -> LayoutMetric

    /// <note>
    /// Returns the content inset on bottom. Do NOT include the safe area and also be sure that the
    /// scroll view has `contentInsetAdjustmentBehavior = .automatic`.
    func bottomInsetWhenKeyboardDidHide(_ keyboardController: KeyboardController) -> LayoutMetric

    /// <note>
    /// Returns the spacing between editing area and keyboard in order to make the editing area more
    /// distinguishable.
    func spacingBetweenEditingRectAndKeyboard(_ keyboardController: KeyboardController) -> LayoutMetric

    func shouldPerformChangesWhenKeyboardDidHide(_ keyboardController: KeyboardController) -> Bool
}

extension KeyboardControllerDataSource {
    public func shouldPerformChangesWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> Bool {
        return shouldPerformChangesWhenKeyboardDidToggle(keyboardController)
    }

    public func keyboardController(
        _ keyboardController: KeyboardController,
        editingRectIn view: UIView
    ) -> CGRect? {
        return nil
    }

    public func bottomInsetOverKeyboardWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }

    public func additionalBottomInsetOverKeyboardWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }

    public func bottomInsetUnderKeyboardWhenKeyboardDidShow(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }

    public func bottomInsetWhenKeyboardDidHide(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 0
    }

    public func spacingBetweenEditingRectAndKeyboard(
        _ keyboardController: KeyboardController
    ) -> LayoutMetric {
        return 8
    }

    public func shouldPerformChangesWhenKeyboardDidHide(
        _ keyboardController: KeyboardController
    ) -> Bool {
        return shouldPerformChangesWhenKeyboardDidToggle(keyboardController)
    }
}

extension KeyboardControllerDataSource {
    private func shouldPerformChangesWhenKeyboardDidToggle(
        _ keyboardController: KeyboardController
    ) -> Bool {
        let screen = keyboardController.screen

        if screen.presentedViewController != nil {
            return false
        }

        if let navigationController = screen.navigationController {
            let visibleScreen = navigationController.viewControllers.last

            if visibleScreen == screen {
                return true
            }

            if visibleScreen == screen.parent {
                return true
            }

            return false
        }

        return true
    }
}
