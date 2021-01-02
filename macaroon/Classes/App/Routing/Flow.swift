// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <note>
/// Identifies a single flow opened directly from the root container, i.e. auth, onboarding, tabs etc.,
/// or before the root container, i.e. splash.
/// If the deeplink flow is a distinct flow, then each one should has its own unique identifier.
/// There shouldn't be a second flow with the same unique identifier in the hierarchy.
public protocol Flow: Equatable {
    var uniqueIdentifier: String { get }

    /// <note>
    /// A special kind of flow to point the root container.
    static var root: Self { get }
    /// <note>
    /// A special kind of flow to point the current flow.
    static var current:  Self { get }

    static func instance(_ identifier: String) -> Self
}

extension Flow {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uniqueIdentifier == rhs.uniqueIdentifier
    }
}
