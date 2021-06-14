// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import LocalAuthentication
import MacaroonUtils

public class BiometricsController<Cache: BiometricsCache> {
    public let policy: LAPolicy

    private let cache: Cache

    public init(
        policy: LAPolicy,
        cache: Cache
    ) {
        self.policy = policy
        self.cache = cache
    }
}

extension BiometricsController {
    public func registerForAuthorization() {
        cache.biometricsAuthorizationStatus = .authorized
    }

    public func unregisterForAuthorization() {
        cache.biometricsAuthorizationStatus = .denied
    }
}

extension BiometricsController {
    public func getBiometricsSettings() -> BiometricsSettings {
        let context = LAContext()

        let isBiometricsAllowed =
            context.canEvaluatePolicy(
                policy,
                error: nil
            )

        let status: BiometricsAuthorizationStatus
        let method: BiometricsAuthorizationMethod

        if isBiometricsAllowed {
            status = cache.biometricsAuthorizationStatus ?? .undetermined

            switch context.biometryType {
            case .none:
                method = .none
            case .faceID:
                method = .faceID
            case .touchID:
                method = .touchID
            @unknown default:
                method = .other
            }
        } else {
            status = .unavailable
            method = .none
        }

        return BiometricsSettings(status: status, method: method)
    }
}

extension BiometricsController {
    public func requestAuthorization(
        localizedReason: String,
        localizedCancelTitle: String,
        onCompleted execute: @escaping (BiometricsAuthorizationResult) -> Void
    ) {
        let settings = getBiometricsSettings()

        switch settings.status {
        case .unavailable:
            execute(.failed(.biometricsUnavailable))
        case .undetermined:
            execute(.failed(.authorizationUndetermined))
        case .authorized:
            evaluateAuthorization(
                localizedReason: localizedReason,
                localizedCancelTitle: localizedCancelTitle,
                onCompleted: execute
            )
        case .denied:
            execute(.failed(.authorizationDenied))
        }
    }

    private func evaluateAuthorization(
        localizedReason: String,
        localizedCancelTitle: String,
        onCompleted execute: @escaping (BiometricsAuthorizationResult) -> Void
    ) {
        let context = LAContext()

        context.localizedCancelTitle = localizedCancelTitle
        context.evaluatePolicy(
            policy,
            localizedReason: localizedReason
        ) { isGranted, error in

            asyncMain {
                let result: BiometricsAuthorizationResult  =
                    isGranted
                        ? .granted
                        : .failed(.authorizationFailed(reason: error as? LAError))
                execute(result)
            }
        }
    }
}

public protocol BiometricsCache: Cache where Key: BiometricsCacheKey {
    var biometricsAuthorizationStatus: BiometricsAuthorizationStatus? { get set }
}

extension BiometricsCache {
    public var biometricsAuthorizationStatus: BiometricsAuthorizationStatus? {
        get {
            let rawValue: String? = self[object: .biometricsAuthorizationStatus]
            return rawValue.unwrap(BiometricsAuthorizationStatus.init)
        }
        set { self[object: .biometricsAuthorizationStatus] = newValue?.rawValue }
    }
}

public protocol BiometricsCacheKey: CacheKey {
    static var biometricsAuthorizationStatus: Self { get }
}
