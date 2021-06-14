// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import WebKit
import UIKit

open class MobileWebView: WKWebView {
    public init() {
        let viewportScriptCode = """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width');
            meta.setAttribute('initial-scale', '1.0');
            meta.setAttribute('maximum-scale', '1.0');
            meta.setAttribute('minimum-scale', '1.0');
            meta.setAttribute('user-scalable', 'no');
            document.getElementsByTagName('head')[0].appendChild(meta);
        """
        let viewportScript =
            WKUserScript(
                source: viewportScriptCode,
                injectionTime: .atDocumentEnd,
                forMainFrameOnly: true
            )

        let userContentController = WKUserContentController()
        userContentController.addUserScript(
            viewportScript
        )

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        super.init(frame: .zero, configuration: configuration)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
