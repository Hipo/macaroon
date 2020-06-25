// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public struct PushNotificationDevice {
    public let platform: PushNotificationPlatform
    public let model: String
    public let locale: String

    public init() {
        platform = .iOS

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

public enum PushNotificationPlatform: String {
    case iOS = "ios"
}
