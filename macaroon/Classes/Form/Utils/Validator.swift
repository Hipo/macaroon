// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Validator {
    var failureMessage: String { get }

    func validate<T>(_ input: T?) -> Bool
}

extension Validator {
    public var failureMessage: String {
        return ""
    }

    public func validate<T>(_ input: T?) -> Bool {
        return true
    }
}

public struct RequiredValidator: Validator {
    public let failureMessage: String

    public init(failureMessage: String = "") {
        self.failureMessage = failureMessage
    }

    public func validate<T>(_ input: T?) -> Bool {
        return input != nil
    }
}

public struct EmptyValidator: Validator {
    public let failureMessage: String

    public init(failureMessage: String = "") {
        self.failureMessage = failureMessage
    }

    public func validate<T>(_ input: T?) -> Bool {
        if let inputString = input as? String {
            return !inputString.isEmpty
        }
        return false
    }
}

public struct EmailValidator: Validator {
    public let failureMessage: String

    private let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    public init(failureMessage: String = "") {
        self.failureMessage = failureMessage
    }

    public func validate<T>(_ input: T?) -> Bool {
        if let inputString = input as? String, !inputString.isEmpty {
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: inputString)
        }
        return false
    }
}
