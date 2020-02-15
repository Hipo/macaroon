// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

open class View<ViewLaunchArgs: ViewLaunchArgsConvertible>: BaseView {
    public init(_ launchArgs: ViewLaunchArgs) {
        super.init(frame: .zero)
        customizeAppearance(launchArgs)
        prepareLayout(launchArgs)
        setListeners()
        linkInteractors()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func customizeAppearance(_ launchArgs: ViewLaunchArgs) { }
    open func prepareLayout(_ launchArgs: ViewLaunchArgs) { }
    open func setListeners() { }
    open func linkInteractors() { }
}

public protocol ViewLaunchArgsConvertible { }

public struct NoViewLaunchArgs: ViewLaunchArgsConvertible { }
