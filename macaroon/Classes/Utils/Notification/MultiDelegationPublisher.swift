// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol MultiDelegationPublisher: AnyObject {
    associatedtype SomeDelegation: Delegation

    var delegations: [ObjectIdentifier: SomeDelegation] { get set }

    func add(delegate: SomeDelegation.Delegate)
    func remove(delegate: SomeDelegation.Delegate)
    func removeAll()
    func notifyDelegates(_ notifier: (SomeDelegation.Delegate) -> Void)
}

extension MultiDelegationPublisher {
    public func removeAll() {
        delegations.removeAll()
    }

    public func notifyDelegates(_ notifier: (SomeDelegation.Delegate) -> Void) {
        delegations.forEach {
            if let delegate = $0.value.delegate {
                notifier(delegate)
            } else {
                delegations[$0.key] = nil
            }
        }
    }
}

public protocol Delegation {
    associatedtype Delegate

    /// <note> It should be defined as a weak variable for no retain cycle.
    var delegate: Delegate? { get }

    init(_ delegate: Delegate)
}
