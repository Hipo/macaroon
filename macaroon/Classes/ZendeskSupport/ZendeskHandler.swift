// Copyright © 2019 hipolabs. All rights reserved.

/// <warning> There are some additional steps to be completed in order to integrate `Zendesk Support`successfully.
///
/// 1. Create a new "Run Scripts Phase" in your app's target's "Build Phases".
/// This script should be the last step in your projects "Build Phases". Paste the following snippet into the script text field:
///
/// `bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/SupportSDK.framework/strip-frameworks.sh"`
///
/// Please ensure your project's VALID_ARCHS build setting does not contain i386 or x86_64 for release configuration.
///
/// 2. The Support SDK uses the camera and photo library in iOS to allow end users to add image attachments to tickets
/// If your app doesn't already request permissions for these features, update your info.plist file with a usage description for NSPhotoLibraryUsageDescription and NSCameraUsageDescription
///
/// 3. To allow your users to attach files to support requests from their iCloud account, you must enable iCloud Documents in your apps Capabilities. (Optional)

import Foundation
import ZendeskCoreSDK
import SupportSDK

open class ZendeskHandler: DevToolConvertible {
    public let config: Config

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let appId = try container.decodeIfPresent(String.self, forKey: .appId) ?? ""
        let clientId = try container.decodeIfPresent(String.self, forKey: .clientId) ?? ""
        let deskUrl = try container.decodeIfPresent(String.self, forKey: .deskUrl) ?? ""
        config = Config(appId: appId, clientId: clientId, deskUrl: deskUrl)

        initialize()
    }

    public required init(nilLiteral: ()) {
        config = Config(appId: "", clientId: "", deskUrl: "")
    }

    open func makeScreen(_ identity: ZendeskIdentity?) -> UIViewController {
        let identity = Identity.createAnonymous(name: identity?.fullName, email: identity?.email)
        Zendesk.instance?.setIdentity(identity)

        return RequestUi.buildRequestUi(with: [])
    }
}

extension ZendeskHandler {
    private func initialize() {
        if config.isValid {
            Zendesk.initialize(appId: config.appId, clientId: config.clientId, zendeskUrl: config.deskUrl)
            Support.initialize(withZendesk: Zendesk.instance)

            debug {
                CoreLogger.logLevel = .debug
                CoreLogger.enabled = true
            }
        }
    }
}

extension ZendeskHandler {
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case clientId = "client_id"
        case deskUrl = "desk_url"
    }
}

extension ZendeskHandler {
    public struct Config {
        public let appId: String
        public let clientId: String
        public let deskUrl: String

        var isValid: Bool {
            return
                !appId.isEmpty &&
                !clientId.isEmpty &&
                !deskUrl.isEmpty
        }
    }
}
