// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol App: AnyObject, AppLaunchable {
    associatedtype SomeTarget: Target
    associatedtype SomeRouter: Router

    var target: SomeTarget { get }
    var router: SomeRouter { get }

    static var shared: Self { get }
}

extension App {
    public var deviceOS: DeviceOS {
        #if os(iOS)
        return .iOS
        #elseif os(watchOS)
        return .watchOS
        #else
        mc_crash(.unsupportedDeviceOS)
        #endif
    }

    public var deviceFamily: DeviceFamily {
        #if os(iOS)
        switch UIScreen.main.traitCollection.userInterfaceIdiom {
        case .unspecified:
            return .iPhone
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            mc_crash(.unsupportedDeviceFamily)
        }
        #elseif os(watchOS)
        return .watch
        #else
        mc_crash(.unsupportedDeviceFamily)
        #endif
    }

    public var hasNotch: Bool {
        return UIApplication.shared.keyWindow.unwrap(ifPresent: { $0.safeAreaInsets.bottom > 0 }, or: false)
    }
}

public enum DeviceOS {
    case iOS
    case watchOS
}

public enum DeviceFamily {
    case iPhone
    case iPad
    case watch
}
