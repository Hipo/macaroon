// Copyright © 2019 hipolabs. All rights reserved.

import ChatSDK
import ChatProvidersSDK
import CommonUISDK
import Foundation
import MessagingSDK
import UIKit

open class ZendeskHandler: Decodable {
    public let config: Config

    private var notifierWhenChatWillAppear: (() -> Void)?
    private var notifierWhenChatDidAppear: (() -> Void)?
    private var notifierWhenChatWillDisappear: (() -> Void)?
    private var notifierWhenChatDidDisappear: (() -> Void)?

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let accountKey = try container.decodeIfPresent(String.self, forKey: .accountKey) ?? ""
        let appId = try container.decodeIfPresent(String.self, forKey: .appId)
        let themeColorName = try container.decodeIfPresent(String.self, forKey: .themeColor)
        config = Config(accountKey: accountKey, appId: appId, themeColorName: themeColorName)

        initialize()
    }

    public required init(nilLiteral: ()) {
        config = Config(accountKey: "", appId: nil, themeColorName: nil)
    }

    open func makeScreen(_ visitor: ZendeskVisitor?) -> UIViewController {
        set(visitor)

        do {
            let chatEngine = try ChatEngine.engine()

            let instance = Messaging.instance
            instance.delegate = self

            let chatConfiguration = ChatConfiguration()
            chatConfiguration.preChatFormConfiguration = ChatFormConfiguration(name: .hidden, email: .hidden, phoneNumber: .hidden, department: .hidden)

            return try instance.buildUI(engines: [chatEngine], configs: [chatConfiguration])
        } catch let error {
            fatalError("Zendesk Chat not initialized properly. Reason: \(error.localizedDescription)")
        }
    }
}

extension ZendeskHandler {
    public func notifyWhenChatWillAppear(execute: @escaping () -> Void) {
        notifierWhenChatWillAppear = execute
    }

    public func notifyWhenChatDidAppear(execute: @escaping () -> Void) {
        notifierWhenChatDidAppear = execute
    }

    public func notifyWhenChatWillDisappear(execute: @escaping () -> Void) {
        notifierWhenChatWillDisappear = execute
    }

    public func notifyWhenChatDidDisappear(execute: @escaping () -> Void) {
        notifierWhenChatDidDisappear = execute
    }
}

extension ZendeskHandler {
    private func initialize() {
        if config.isValid {
            Chat.initialize(accountKey: config.accountKey, appId: config.appId)

            if let themeColor = config.themeColor {
                CommonTheme.currentTheme.primaryColor = themeColor
            }

            /// <warning> I didn't see any log to be printed.
            debug {
                Logger.isEnabled = true
                Logger.defaultLevel = .verbose
            }
        }
    }

    private func set(_ visitor: ZendeskVisitor?) {
        let configuration = ChatAPIConfiguration()
        configuration.visitorInfo = VisitorInfo(name: visitor.unwrap(ifPresent: \.fullName, or: ""), email: visitor.unwrap(ifPresent: \.email, or: ""), phoneNumber: visitor.unwrap(ifPresent: \.phoneNumber, or: ""))
        Chat.instance?.configuration = configuration
    }
}

extension ZendeskHandler {
    enum CodingKeys: String, CodingKey {
        case accountKey = "account_key"
        case appId = "app_id"
        case themeColor = "theme_color"
    }
}

extension ZendeskHandler {
    public struct Config {
        public var themeColor: UIColor? {
            return try? themeColorName.unwrap({ col($0) })
        }

        public let accountKey: String
        public let appId: String?
        public let themeColorName: String?

        var isValid: Bool {
            return !accountKey.isEmpty
        }
    }
}

extension ZendeskHandler: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didPerformEvent event: MessagingUIEvent, context: Any?) {
        switch event {
        case .viewWillAppear:
            notifierWhenChatWillAppear?()
        case .viewDidAppear:
            notifierWhenChatDidAppear?()
        case .viewWillDisappear:
            notifierWhenChatWillDisappear?()
        case .viewDidDisappear:
            notifierWhenChatDidDisappear?()
        default:
            break
        }
    }

    public func messaging(_ messaging: Messaging, shouldOpenURL url: URL) -> Bool {
        return true
    }
}
