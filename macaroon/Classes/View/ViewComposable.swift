// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewComposable: UIView {
    func customizeAppearance()
    func prepareLayout()
    func setListeners() /// Set dataSource(s)&delegate(s)
    func linkInteractors() /// Link action-target(s)

    func prepareForReuse() /// Reset view state if needed.
}

extension ViewComposable {
    public func compose() {
        customizeAppearance()
        prepareLayout()
        setListeners()
        linkInteractors()
    }
}
