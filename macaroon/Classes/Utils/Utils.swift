// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <mark> Error
public func mc_crash(_ error: Error) -> Never {
    crash(error)
}

public func crash(_ error: ErrorConvertible) -> Never {
    fatalError(error.localizedDescription)
}

/// <mark> Colors
public func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return rgba(red, green, blue, 1.0)
}

public func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: red, green: green, blue: blue, alpha: min(1.0, max(0.0, alpha)))
}

public func col(_ named: String) -> UIColor {
    if let color = UIColor(named: named) {
        return color
    }
    mc_crash(.colorNotFound(named))
}

/// <mark> Images
public func img(_ named: String) -> UIImage {
    if let image = UIImage(named: named) {
        return image
    }
    mc_crash(.imageNotFound(named))
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

public func iOS13AndLater<T>(execute: () -> T, else elseExecute: () -> T) -> T {
    if #available(iOS 13, *) {
        return execute()
    }
    return elseExecute()
}

public func iOS12AndBefore(execute: () -> Void) {
    if #available(iOS 13, *) { }
    else {
        execute()
    }
}

public func iOS12AndBefore<T>(execute: () -> T, else elseExecute: () -> T) -> T {
    if #available(iOS 13, *) {
        return elseExecute()
    }
    return execute()
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
