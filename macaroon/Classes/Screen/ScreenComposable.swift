// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ScreenComposable: AnyObject {
    func customizeAppearance()
    func prepareLayout()
    func setListeners() /// <note> Set dataSource(s) & delegate(s)
    func linkInteractors() /// <note> Link action-target(s)
}

extension ScreenComposable {
    public func compose() {
        customizeAppearance()
        prepareLayout()
        setListeners()
        linkInteractors()
    }
}
