// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <mark> Error
public func mc_crash(_ error: Error) -> Never {
    crash(error)
}

public func crash(_ error: Swift.Error) -> Never {
    fatalError(error.localizedDescription)
}

/// <mark> GCD
public func asyncMain(execute: @escaping () -> Void) {
    DispatchQueue.main.async(execute: execute)
}

public func asyncMainAfter(_ duration: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: execute)
}

public func asyncBackground(qos: DispatchQoS.QoSClass = .background, execute: @escaping () -> Void) {
    DispatchQueue.global(qos: qos).async(execute: execute)
}

/// <mark> Availability
public func iOS13AndLater(execute: () -> Void) {
    if #available(iOS 13, *) {
        execute()
    }
}

public func iOS13AndLater(execute: () -> Void, else elseExecute: () -> Void) {
    if #available(iOS 13, *) {
        execute()
    } else {
        elseExecute()
    }
}

//// <mark> Debug
public func debug(_ execute: () -> Void) {
    #if DEBUG
    execute()
    #endif
}

public func release(_ execute: () -> Void) {
    #if !DEBUG
    execute()
    #endif
}
