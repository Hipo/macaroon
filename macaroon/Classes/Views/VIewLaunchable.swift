// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ViewLaunchable: UIView {
    associatedtype ViewLaunchArgs: ViewLaunchArgsConvertible

    var launchArgs: ViewLaunchArgs { get }
}

extension ViewLaunchable {
    public var styleGuide: ViewLaunchArgs.StyleGuide {
        return launchArgs.styleGuide
    }
}

public protocol ViewLaunchArgsConvertible {
    associatedtype StyleGuide: StyleGuideConvertible

    var styleGuide: StyleGuide { get }
}

public protocol BindableViewLaunchArgsConvertible: ViewLaunchArgsConvertible {
    associatedtype ViewModel: ViewModelConvertible
}

open class ViewLaunchArgs<StyleGuide: StyleGuideConvertible>: ViewLaunchArgsConvertible {
    public let styleGuide: StyleGuide

    public init(_ styleGuide: StyleGuide) {
        self.styleGuide = styleGuide
    }
}

public class NoViewLaunchArgs: ViewLaunchArgsConvertible {
    public let styleGuide = NoStyleGuide()

    public init() { }
}
