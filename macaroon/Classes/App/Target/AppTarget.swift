// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol AppTarget: AnyObject, Decodable {
    var isDevelopment: Bool { get }
}

extension AppTarget {
    public var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier.nonNil
    }
    public var displayName: String {
        let infoDictionary = Bundle.main.infoDictionary
        return ((infoDictionary?["CFBundleDisplayName"] ?? infoDictionary?["CFBundleName"]) as? String).nonNil
    }
    public var version: AppVersion {
        let versionString = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String).nonNil
        return AppVersion(versionString: versionString)
    }

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

extension AppTarget {
    /// <note>
    /// - Config file must be in JSON format, keys should be snake case.
    /// - Config file must be saved in the 'main' bundle.
    /// - It is highly recommended for each app target to have its own config file.
    public static func load(fromResource name: String = "AppTargetConfig", withExtension ext: String = "json") -> Self {
        guard let resourceUrl = Bundle.main.url(forResource: name, withExtension: ext) else {
            mc_crash(.appTargetNotFound)
        }
        do {
            let data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.uncached)

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: data)
        } catch let err {
            mc_crash(.appTargetCorrupted(reason: err))
        }
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
