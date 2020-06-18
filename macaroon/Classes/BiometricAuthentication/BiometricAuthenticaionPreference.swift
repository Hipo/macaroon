// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public struct BiometricAuthenticaionPreference {
    let storeKey: String
    let authRequestReason: String
    let authPolicy: AuthenticationPolicy
    
    public init(storeKey: String, authRequestReason: String, authPolicy: AuthenticationPolicy) {
        self.storeKey = storeKey
        self.authRequestReason = authRequestReason
        self.authPolicy = authPolicy
    }
}

extension BiometricAuthenticaionPreference {
    public enum AuthenticationPolicy {
        case onlyBiometrics
        case biometricWithPasscode
    }
}
