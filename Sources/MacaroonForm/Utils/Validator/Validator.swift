// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import MacaroonUIKit

public protocol Validator {
    func validate(_ inputFieldView: FormInputFieldView) -> Validation
    func getMessage(for error: ValidationError) -> EditText?
}

public protocol ValidationError {}

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
