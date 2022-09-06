// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonResources
import MacaroonUtils
import UIKit

public protocol ScreenLifeCycleObserver: Hashable, AnyObject {
    func viewDidLoad(
        _ screen: Screen
    )
    func viewDidLayoutSubviews(
        _ screen: Screen
    )
    func viewWillAppear(
        _ screen: Screen
    )
    func viewDidFirstAppear(
        _ screen: Screen
    )
    func viewDidAppear(
        _ screen: Screen
    )
    func viewDidAppearAfterDismiss(
        _ screen: Screen
    )
    func viewDidAppearAfterInteractiveDismiss(
        _ screen: Screen
    )
    func viewWillDisappear(
        _ screen: Screen
    )
    func viewDidDisappear(
        _ screen: Screen
    )
    func viewDidAttempInteractiveDismiss(
        _ screen: Screen
    )

    func viewDidChangePreferredUserInterfaceStyle(
        _ screen: Screen
    )
    func viewDidChangePreferredContentSizeCategory(
        _ screen: Screen
    )

    /// <warning>
    /// These methods are called only if the required notifications are obsrved.
    func viewWillEnterForeground(
        _ screen: Screen
    )
    func viewDidEnterBackground(
        _ screen: Screen
    )
}

extension ScreenLifeCycleObserver {
    public func viewDidLoad(
        _ screen: Screen
    ) {}

    public func viewDidLayoutSubviews(
        _ screen: Screen
    ) {}

    public func viewWillAppear(
        _ screen: Screen
    ) {}

    public func viewDidFirstAppear(
        _ screen: Screen
    ) {}

    public func viewDidAppear(
        _ screen: Screen
    ) {}

    public func viewDidAppearAfterDismiss(
        _ screen: Screen
    ) {}

    public func viewDidAppearAfterInteractiveDismiss(
        _ screen: Screen
    ) {}

    public func viewWillDisappear(
        _ screen: Screen
    ) {}

    public func viewDidDisappear(
        _ screen: Screen
    ) {}

    public func viewDidAttempInteractiveDismiss(
        _ screen: Screen
    ) {}

    public func viewDidChangePreferredUserInterfaceStyle(
        _ screen: Screen
    ) {}

    public func viewDidChangePreferredContentSizeCategory(
        _ screen: Screen
    ) {}

    public func viewWillEnterForeground(
        _ screen: Screen
    ) {}

    public func viewDidEnterBackground(
        _ screen: Screen
    ) {}
}

extension ScreenLifeCycleObserver {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

public final class AnyScreenLifeCycleObserver: ScreenLifeCycleObserver {
    private let _viewDidLoad: (Screen) -> Void
    private let _viewDidLayoutSubviews: (Screen) -> Void
    private let _viewWillAppear: (Screen) -> Void
    private let _viewDidFirstAppear: (Screen) -> Void
    private let _viewDidAppear: (Screen) -> Void
    private let _viewDidAppearAfterDismiss: (Screen) -> Void
    private let _viewDidAppearAfterInteractiveDismiss: (Screen) -> Void
    private let _viewWillDisappear: (Screen) -> Void
    private let _viewDidDisappear: (Screen) -> Void
    private let _viewDidAttempInteractiveDismiss: (Screen) -> Void
    private let _viewDidChangePreferredUserInterfaceStyle: (Screen) -> Void
    private let _viewDidChangePreferredContentSizeCategory: (Screen) -> Void
    private let _viewWillEnterForeground: (Screen) -> Void
    private let _viewDidEnterBackground: (Screen) -> Void

    private let observerID: ObjectIdentifier

    public init<T: ScreenLifeCycleObserver>(
        _ observer: T
    ) {
        self._viewDidLoad = observer.viewDidLoad
        self._viewDidLayoutSubviews = observer.viewDidLayoutSubviews
        self._viewWillAppear = observer.viewWillAppear
        self._viewDidFirstAppear = observer.viewDidFirstAppear
        self._viewDidAppear = observer.viewDidAppear
        self._viewDidAppearAfterDismiss = observer.viewDidAppearAfterDismiss
        self._viewDidAppearAfterInteractiveDismiss = observer.viewDidAppearAfterInteractiveDismiss
        self._viewWillDisappear = observer.viewWillDisappear
        self._viewDidDisappear = observer.viewDidDisappear
        self._viewDidAttempInteractiveDismiss = observer.viewDidAttempInteractiveDismiss
        self._viewDidChangePreferredUserInterfaceStyle = observer.viewDidChangePreferredUserInterfaceStyle
        self._viewDidChangePreferredContentSizeCategory = observer.viewDidChangePreferredContentSizeCategory
        self._viewWillEnterForeground = observer.viewWillEnterForeground
        self._viewDidEnterBackground = observer.viewDidEnterBackground
        self.observerID = ObjectIdentifier(observer)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(observerID)
    }

    public static func == (
        lhs: AnyScreenLifeCycleObserver,
        rhs: AnyScreenLifeCycleObserver
    ) -> Bool {
        return lhs.observerID == rhs.observerID
    }
}

/// <mark>
/// ScreenLifeCycleObserver
extension AnyScreenLifeCycleObserver {
    public func viewDidLoad(
        _ screen: Screen
    ) {
        _viewDidLoad(screen)
    }

    public func viewDidLayoutSubviews(
        _ screen: Screen
    ) {
        _viewDidLayoutSubviews(screen)
    }

    public func viewWillAppear(
        _ screen: Screen
    ) {
        _viewWillAppear(screen)
    }

    public func viewDidFirstAppear(
        _ screen: Screen
    ) {
        _viewDidFirstAppear(screen)
    }

    public func viewDidAppear(
        _ screen: Screen
    ) {
        _viewDidAppear(screen)
    }

    public func viewDidAppearAfterDismiss(
        _ screen: Screen
    ) {
        _viewDidAppearAfterDismiss(screen)
    }

    public func viewDidAppearAfterInteractiveDismiss(
        _ screen: Screen
    ) {
        _viewDidAppearAfterInteractiveDismiss(screen)
    }

    public func viewWillDisappear(
        _ screen: Screen
    ) {
        _viewWillDisappear(screen)
    }

    public func viewDidDisappear(
        _ screen: Screen
    ) {
        _viewDidDisappear(screen)
    }

    public func viewDidAttempInteractiveDismiss(
        _ screen: Screen
    ) {
        _viewDidAttempInteractiveDismiss(screen)
    }

    public func viewDidChangePreferredUserInterfaceStyle(
        _ screen: Screen
    ) {
        _viewDidChangePreferredUserInterfaceStyle(screen)
    }

    public func viewDidChangePreferredContentSizeCategory(
        _ screen: Screen
    ) {
        _viewDidChangePreferredContentSizeCategory(screen)
    }

    public func viewWillEnterForeground(
        _ screen: Screen
    ) {
        _viewWillEnterForeground(screen)
    }

    public func viewDidEnterBackground(
        _ screen: Screen
    ) {
        _viewDidEnterBackground(screen)
    }
}
