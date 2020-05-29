// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol MultiDelegationPublisher: AnyObject {
    associatedtype SomeDelegation: Delegation

    var delegations: [ObjectIdentifier: SomeDelegation] { get set }

    func add(delegate: SomeDelegation.Delegate)
    func remove(delegate: SomeDelegation.Delegate)
}

extension MultiDelegationPublisher {
    public func add(delegate: SomeDelegation.Delegate) {
        if let validDelegate = delegate as? AnyObject {
            let id = ObjectIdentifier(validDelegate)
            delegations[id] = SomeDelegation(delegate)
        }
    }

    public func remove(delegate: SomeDelegation.Delegate) {
        if let validDelegate = delegate as? AnyObject {
            let id = ObjectIdentifier(validDelegate)
            delegations[id] = nil
        }
    }

    public func removeAllDelegates() {
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
