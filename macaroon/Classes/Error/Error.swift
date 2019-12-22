// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public enum Error: ErrorConvertible {
    case targetNotFound
    case targetCorrupted(reason: ErrorConvertible)
    case unsupportedDeviceOS
    case unsupportedDeviceFamily
    case rootContainerNotMatch
    case ambiguous
}

extension Error {
    public var localizedDescription: String {
        switch self {
        case .targetNotFound:
            return "Target not found"
        case .targetCorrupted(let reason):
            return "Target corrupted: \(reason.localizedDescription)"
        case .unsupportedDeviceOS:
            return "Unsupported device operating system"
        case .unsupportedDeviceFamily:
            return "Unsupported device family"
        case .rootContainerNotMatch:
            return "Root container in window doesn't match the expected one"
        case .ambiguous:
            return "Ambiguous error"
        }
    }
}
