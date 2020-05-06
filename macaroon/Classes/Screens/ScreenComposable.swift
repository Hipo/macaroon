// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ScreenComposable: UIViewController {
    func customizeAppearance()
    func prepareLayout()
    func updateLayoutWhenViewDidLayoutSubviews()
    func setListeners() /// <note> Set dataSource(s) & delegate(s)
    func linkInteractors() /// <note> Link action-target(s)
}

extension ScreenComposable {
    public func updateLayoutWhenViewDidLayoutSubviews() { }
    public func setListeners() { }
    public func linkInteractors() { }
}

extension ScreenComposable {
    public func compose() {
        customizeAppearance()
        prepareLayout()
        setListeners()
        linkInteractors()
    }
}
