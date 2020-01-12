// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public enum Error: ErrorConvertible {
    case targetNotFound
    case targetCorrupted(reason: ErrorConvertible)
    case unsupportedDeviceOS
    case unsupportedDeviceFamily
    case rootContainerNotMatch
    case routerNotFound
    case screenNotFound(AppRoutingDestination)
    case dismissNavigationBarItemNotFound
    case popNavigationBarItemNotFound
    case colorNotFound(String)
    case imageNotFound(String)
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
        case .routerNotFound:
            return "Router not found"
        case .screenNotFound(let destination):
            return "Screen not found for \(destination)"
        case .dismissNavigationBarItemNotFound:
            return "Navigation bar button item not found for dismissing action"
        case .popNavigationBarItemNotFound:
            return "Navigation bar button item not found for popping action"
        case .colorNotFound(let name):
            return "Color(\(name)) not found"
        case .imageNotFound(let name):
            return "Image(\(name)) not found"
        case .ambiguous:
            return "Ambiguous error"
        }
    }
}
