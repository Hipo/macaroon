// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class BannerController {
    open var edgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    private(set) var visibleBanners: [Banner] = []

    private var operationQueue: [BannerOperation] = []

    private var hasOngoingAnimation = false

    private lazy var stackView = UIStackView()

    open func show(banner: Banner) {
    }

    open func hide(banner: Banner) {
    }
}

enum BannerOperation {
    case show(Banner)
    case hide(Banner)
}
