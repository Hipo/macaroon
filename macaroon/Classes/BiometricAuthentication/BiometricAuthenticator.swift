// Copyright © 2019 hipolabs. All rights reserved.

import LocalAuthentication

public class BiometricAuthenticator {

    private let preferences: BiometricAuthenticaionPreference
    
    private var context = LAContext()
    
    public var authenticationError: NSError?

    private var authenticationPolicy: LAPolicy {
        return preferences.authPolicy == .onlyBiometrics ? .deviceOwnerAuthenticationWithBiometrics : .deviceOwnerAuthentication
    }
    
    public var isAvailable: Bool {
        return context.canEvaluatePolicy(authenticationPolicy, error: &authenticationError)
    }
    
    public var status: Status {
        get {
            guard let storedStatus = UserDefaults.standard.string(forKey: preferences.storeKey),
                let biometricAuthenticationStatus = Status(rawValue: storedStatus) else {
                    return .none
            }
            
            return biometricAuthenticationStatus
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, for: preferences.storeKey)
        }
    }
    
    public var type: Type {
        if !isAvailable {
            return .none
        }
        
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
    public init(preferences: BiometricAuthenticaionPreference) {
        self.preferences = preferences
        awakeBiometricAuthenticationStatusFromStorage()
    }
    
    private func awakeBiometricAuthenticationStatusFromStorage() {
        guard let storedStatus = UserDefaults.standard.string(forKey: preferences.storeKey),
            let biometricAuthenticationStatus = Status(rawValue: storedStatus) else {
            return
        }
        
        self.status = biometricAuthenticationStatus
    }
}

extension BiometricAuthenticator {
    public func requestAuthentication(completion: @escaping (_ error: Error?) -> Void) {
        if !isAvailable {
            completion(.failedBiometricAuthentication(reason: AvailabilityError()))
            return
        }
        
        context.evaluatePolicy(authenticationPolicy, localizedReason: preferences.authRequestReason) { isSuccessful, error in
            if isSuccessful {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failedBiometricAuthentication(reason: error))
                        return
                    }
                }
            }
        }
    }

    public func reset() {
        context = LAContext()
    }
}

extension BiometricAuthenticator {
    public enum `Type` {
        case faceID
        case touchID
        case none
    }
}

extension BiometricAuthenticator {
    public enum Status: String {
        case allowed = "enabled"
        case notAllowed = "disabled"
        case none = "none"
    }
}

extension BiometricAuthenticator {
    private struct AvailabilityError: Swift.Error {
        var localizedDescription: String {
            return "Biometric Authentication is not available."
        }
    }
}
