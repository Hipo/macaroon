// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListComposable: UIView {
    associatedtype ContextView: ViewComposable

    var contextView: ContextView { get }

    func getContextView() -> ContextView
    func customizeAppearance(_ styleSheet: ContextView.StyleSheet)
    func prepareLayout(_ layoutSheet: ContextView.LayoutSheet)
}

extension ListComposable {
    public func customizeAppearance(_ styleSheet: ContextView.StyleSheet) {
        contextView.customizeAppearance(styleSheet)
    }

    public func prepareLayout(_ layoutSheet: ContextView.LayoutSheet) {
        contextView.prepareLayout(layoutSheet)
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

extension ListComposable where Self: ViewModelBindable & ListSeparatorAdaptable, Self.ContextView: ViewModelBindable {
    public static func calculatePreferredSize(_ viewModel: ContextView.ViewModel?, fittingIn size: CGSize) -> CGSize {
        let preferredSize = ContextView.calculatePreferredSize(viewModel, fittingIn: size)
        return CGSize(width: preferredSize.width, height: preferredSize.height + separatorStyle.margin)
    }
}
