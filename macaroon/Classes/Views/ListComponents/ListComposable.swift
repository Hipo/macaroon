// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListComposable: UIView {
    associatedtype ContextView: ViewComposable

    var contextView: ContextView { get }

    func getContextView() -> ContextView
    func customizeAppearance(_ styleGuide: ContextView.StyleGuide)
}

extension ListComposable {
    public func customizeAppearance(_ styleGuide: ContextView.StyleGuide) {
        contextView.customizeAppearance(styleGuide)
    }
}

extension ListComposable where Self: ViewModelBindable, Self.ContextView: ViewModelBindable {
    public func bind(_ viewModel: ContextView.ViewModel?) {
        contextView.bind(viewModel)
    }

    public static func calculatePreferredSize(_ viewModel: ContextView.ViewModel?, fittingIn size: CGSize) -> CGSize {
        return ContextView.calculatePreferredSize(viewModel, fittingIn: size)
    }
}
