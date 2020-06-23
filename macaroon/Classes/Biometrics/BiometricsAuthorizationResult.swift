// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import LocalAuthentication

public enum BiometricsAuthorizationResult {
    case granted
    case failed(BiometricsAuthorizationError)
}

public enum BiometricsAuthorizationError {
    case biometricsUnavailable
    case authorizationUndetermined
    case authorizationDenied
    case authorizationFailed(reason: LAError?)
}
