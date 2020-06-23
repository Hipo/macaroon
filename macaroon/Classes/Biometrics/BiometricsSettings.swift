// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct BiometricsSettings {
    public let status: BiometricsAuthorizationStatus
    public let method: BiometricsAuthorizationMethod

    public func canSupportBiometrics() -> Bool {
        return status != .unavailable
    }
}

public enum BiometricsAuthorizationStatus: String {
    case unavailable
    case undetermined
    case authorized
    case denied
}

public enum BiometricsAuthorizationMethod: String {
    case none
    case faceID
    case touchID
    case other
}
