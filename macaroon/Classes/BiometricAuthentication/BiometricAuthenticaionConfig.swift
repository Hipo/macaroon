// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct BiometricAuthenticaionConfig {
    let storeKey: String
    let authRequestReason: String
    let authPolicy: AuthenticationPolicy
    
    public init(storeKey: String, authRequestReason: String, authPolicy: AuthenticationPolicy) {
        self.storeKey = storeKey
        self.authRequestReason = authRequestReason
        self.authPolicy = authPolicy
    }
}

extension BiometricAuthenticaionConfig {
    public enum AuthenticationPolicy {
        case onlyBiometrics
        case biometricWithPasscode
    }
}
