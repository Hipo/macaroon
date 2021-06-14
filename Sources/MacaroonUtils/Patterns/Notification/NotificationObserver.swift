// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol NotificationObserver: AnyObject {
    var observations: [NSObjectProtocol] { get set }
}

extension NotificationObserver {
    public typealias ObservationBlock = (Notification) -> Void

    public func observe(
        notification name: Notification.Name,
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: name,
            by: nil,
            on: OperationQueue.main,
            using: block
        )
    }

    public func observe(
        notification name: Notification.Name,
        by object: Any?,
        on queue: OperationQueue?,
        using block: @escaping ObservationBlock
    ) {
        let observer =
            NotificationCenter.default.addObserver(
                forName: name,
                object: object,
                queue: queue,
                using: block
            )
        observations.append(observer)
    }

    public func unobserveNotifications() {
        observations.forEach(NotificationCenter.default.removeObserver)
        observations = []
    }
}

/// <mark>
/// Application Life Cycle
extension NotificationObserver {
    public func observeWhenApplicationWillEnterForeground(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIApplication.willEnterForegroundNotification,
            using: block
        )
    }

    public func observeWhenApplicationDidBecomeActive(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIApplication.didBecomeActiveNotification,
            using: block
        )
    }

    public func observeWhenApplicationWillResignActive(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIApplication.willResignActiveNotification,
            using: block
        )
    }

    public func observeWhenApplicationDidEnterBackground(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIApplication.didEnterBackgroundNotification,
            using: block
        )
    }
}

/// <mark>
/// Keyboard Life Cycle
extension NotificationObserver {
    public func observeWhenKeyboardWillShow(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIResponder.keyboardWillShowNotification,
            using: block
        )
    }

    public func observeWhenKeyboardWillHide(
        using block: @escaping ObservationBlock
    ) {
        observe(
            notification: UIResponder.keyboardWillHideNotification,
            using: block
        )
    }
}
