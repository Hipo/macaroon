// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import LocalAuthentication

public class BiometricsController {
    public let policy: LAPolicy

    private let cache = UserCache()
    private let authorizationStatusCacheKey = "biometricsController.registrationStatus"

    public init(policy: LAPolicy) {
        self.policy = policy
    }
}

extension BiometricsController {
    public func registerForAuthorization() {
        cache.set(object: BiometricsAuthorizationStatus.authorized.rawValue, for: authorizationStatusCacheKey)
    }

    public func unregisterForAuthorization() {
        cache.set(object: BiometricsAuthorizationStatus.denied.rawValue, for: authorizationStatusCacheKey)
    }
}

extension BiometricsController {
    public func getBiometricsSettings() -> BiometricsSettings {
        let context = LAContext()

        let status: BiometricsAuthorizationStatus
        let method: BiometricsAuthorizationMethod

        if context.canEvaluatePolicy(policy, error: nil) {
            if let statusKey: String = cache.getObject(for: authorizationStatusCacheKey),
               let savedStatus = BiometricsAuthorizationStatus(rawValue: statusKey) {
                status = savedStatus
            } else {
                status = .undetermined
            }

            switch context.biometryType {
            case .none:
                method = .none
            case .faceID:
                method = .faceID
            case .touchID:
                method = .touchID
            }
        } else {
            status = .unavailable
            method = .none
        }
        return BiometricsSettings(status: status, method: method)
    }
}

extension BiometricsController {
    public func requestAuthorization(localizedReason: String, localizedCancelTitle: String, onCompleted execute: @escaping (BiometricsAuthorizationResult) -> Void) {
        let settings = getBiometricsSettings()

        switch settings.status {
        case .unavailable:
            execute(.failed(.biometricsUnavailable))
        case .undetermined:
            execute(.failed(.authorizationUndetermined))
        case .authorized:
            evaluateAuthorization(localizedReason: localizedReason, localizedCancelTitle: localizedCancelTitle, onCompleted: execute)
        case .denied:
            execute(.failed(.authorizationDenied))
        }
    }

    private func evaluateAuthorization(localizedReason: String, localizedCancelTitle: String, onCompleted execute: @escaping (BiometricsAuthorizationResult) -> Void) {
        let context = LAContext()

        context.localizedCancelTitle = localizedCancelTitle
        context.evaluatePolicy(policy, localizedReason: localizedReason) { isGranted, error in
            asyncMain {
                execute(isGranted ? .granted : .failed(.authorizationFailed(reason: error as? LAError)))
            }
        }
    }
}
