// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct Device {
    public let platform: DevicePlatform
    public let platformVersion: String
    public let identifier: String
    public let model: String
    public let locale: String

    public init() {
        platform = .iOS

        let rawDevice = UIDevice.current
        platformVersion = rawDevice.systemVersion
        identifier = rawDevice.identifierForVendor?.uuidString ?? ""

        #if targetEnvironment(simulator)
        model = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "simulator"
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        model = machineMirror.children.reduce("") { aModel, elem in
            guard let value = elem.value as? Int8, value != 0 else {
                return aModel
            }
            return aModel + String(UnicodeScalar(UInt8(value)))
        }
        #endif

        locale = Locale.current.identifier
    }
}

public enum DevicePlatform: String {
    case iOS = "ios"
}
