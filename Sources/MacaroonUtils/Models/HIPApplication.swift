// Copyright © Hipolabs. All rights reserved.

import Foundation

open class HIPApplication: Printable {
    public var debugDescription: String {
        return "\(name) v\(version) (\(packageName))"
    }

    public let name: String
    public let packageName: String
    public let version: String

    public init() {
        let mainBundle = Bundle.main
        let infoDictionary = mainBundle.infoDictionary

        name = (infoDictionary?["CFBundleDisplayName"] ?? infoDictionary?["CFBundleName"]) as? String ?? ""
        packageName = mainBundle.bundleIdentifier ?? ""
        version = [
            infoDictionary?["CFBundleShortVersionString"] as? String,
            infoDictionary?["CFBundleVersion"] as? String
        ]
        .compactMap { $0 }
        .joined(separator: "-")
    }
}
