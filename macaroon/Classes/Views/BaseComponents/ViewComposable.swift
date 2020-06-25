// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ViewComposable: UIView {
    associatedtype StyleGuide
    associatedtype LayoutGuide

    func customizeAppearance(_ styleGuide: StyleGuide)
    func prepareLayout(_ layoutGuide: LayoutGuide)
    
    func prepareLayout()
    func setListeners()
    func linkInteractors()
}

extension ViewComposable {
    public func setListeners() { }
    public func linkInteractors() { }
}
