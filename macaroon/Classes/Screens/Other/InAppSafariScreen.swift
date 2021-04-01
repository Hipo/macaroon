// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import SafariServices
import UIKit

public final class InAppSafariScreen:
    SFSafariViewController,
    ScreenRoutable {
    public var flowIdentifier: String = ""
    public var pathIdentifier: String = ""

    public override init(
        url URL: URL,
        configuration: SFSafariViewController.Configuration
    ) {
        super.init(
            url: URL,
            configuration: configuration
        )
    }

    public convenience init(
        url: URL
    ) {
        self.init(
            url: url,
            configuration: SFSafariViewController.Configuration()
        )
    }
}
