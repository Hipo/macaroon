// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol Validator {
    func validate(_ inputFieldView: FormInputFieldView) -> Validation
}

public protocol ValidationError {
    var reason: String { get }
}

extension String: ValidationError {
    public var reason: String {
        return self
    }
}

public enum Validation {
    case success
    case failure(ValidationError)
}

extension Validation {
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    public var isFailure: Bool {
        return !self.isSuccess
    }
}
