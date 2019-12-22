// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <mark> Error
public func mc_crash(_ error: Error) -> Never {
    crash(error)
}

public func crash(_ error: ErrorConvertible) -> Never {
    fatalError(error.localizedDescription)
}

/// <mark> GCD
func asyncMain(execute: @escaping () -> Void) {
    DispatchQueue.main.async(execute: execute)
}

func asyncMainAfter(_ duration: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: execute)
}

func asyncBackground(qos: DispatchQoS.QoSClass = .background, execute: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: execute)
}
