// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListPresentable: UIView {
    associatedtype ContextView: UIView & ListReusable

    var contextView: ContextView { get }
}

extension ListPresentable where Self: ViewModelBindable, Self.ContextView: ViewModelBindable, ViewModel == Self.ContextView.ViewModel {
    public func bind(_ viewModel: ViewModel) {
        contextView.bind(viewModel)
    }

    public static func calculatePreferredSize(_ viewModel: ViewModel, fittingIn size: CGSize) -> CGSize {
        return ContextView.calculatePreferredSize(viewModel, fittingIn: size)
    }
}
