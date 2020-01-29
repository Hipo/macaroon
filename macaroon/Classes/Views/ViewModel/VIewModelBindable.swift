// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ViewModelBindable: UIView {
    associatedtype ViewModel: ViewModelConvertible

    func bind(_ viewModel: ViewModel)
    static func calculatePreferredSize(_ viewModel: ViewModel, fittingIn size: CGSize) -> CGSize
}

extension ViewModelBindable {
    public static func calculatePreferredSize(_ viewModel: ViewModel, fittingIn size: CGSize) -> CGSize {
        return .zero
    }
}
