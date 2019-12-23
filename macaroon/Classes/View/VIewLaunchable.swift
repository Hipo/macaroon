// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewLaunchable: UIView {
    associatedtype SomeViewLaunchArgs: ViewLaunchArgsConvertible

    var launchArgs: SomeViewLaunchArgs { get }
}

extension ViewLaunchable {
    public var styleGuide: SomeViewLaunchArgs.SomeStyleGuide {
        return launchArgs.styleGuide
    }
}

public protocol ViewLaunchArgsConvertible {
    associatedtype SomeStyleGuide: StyleGuide

    var styleGuide: SomeStyleGuide { get }
}

public protocol BindableViewLaunchArgsConvertible: ViewLaunchArgsConvertible {
    associatedtype SomeViewModel: ViewModel
}

public struct NoViewLaunchArgs: ViewLaunchArgsConvertible {
    public let styleGuide = NoStyleGuide()

    public init() { }
}
