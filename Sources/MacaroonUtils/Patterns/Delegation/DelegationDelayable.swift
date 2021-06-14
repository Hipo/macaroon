// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <note>
/// If there is a possibility that a delegate may not exists at the moment a delegation needs to be
/// dispatched. Therefore, using this protocol as base, it is possible to delay a delegation and call
/// it later once it is safe to run.
public protocol DelegationDelayable: AnyObject {
    typealias Delegation = (Self, Delegate) -> Void

    associatedtype Delegate

    var delegate: Delegate? { get set }
    var delayedDelegation: ((Delegate) -> Void)? { get set }
}

extension DelegationDelayable {
    public func delayDelegationIfNeeded(
        _ delegation: @escaping Delegation
    ) {
        guard let delegate = delegate else {
            delayDelegation(delegation)
            return
        }

        delegation(self, delegate)
    }

    public func delayDelegation(
        _ delegation: @escaping Delegation
    ) {
        delayedDelegation = {
            [weak self] aDelegate in

            guard let self = self else {
                return
            }

            delegation(self, aDelegate)
        }
    }

    public func resumeDelayedDelegation() {
        guard let delegate = delegate else {
            return
        }

        delayedDelegation?(delegate)
        delayedDelegation = nil
    }
}
