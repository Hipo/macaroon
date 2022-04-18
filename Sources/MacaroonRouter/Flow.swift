// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUtils

/// <note>
/// Identifies a single flow opened directly from the root container, i.e. auth, onboarding, tabs etc.,
/// or before the root container, i.e. splash.
/// If the deeplink flow is a distinct flow, then each one should has its own unique identifier.
/// There shouldn't be a second flow with the same unique identifier in the hierarchy.
public protocol Flow {
    typealias TransitionBuilder = (Router) -> Transition
    /// <note>
    /// It should be unique for every flow out there.
    var identifier: String { get }
    var build: TransitionBuilder? { get }
}

extension Flow {
    public func equals(
        to aFlow: Flow
    ) -> Bool {
        return identifier == aFlow.identifier
    }
}

public struct AnyFlow: Flow {
    public let identifier: String
    public let build: TransitionBuilder?
    
    public init(
        _ identifier: String
    ) {
        self.identifier = identifier
        self.build = nil
    }
}
