// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ViewModelBindable {
    associatedtype ViewModel: ViewModelConvertible

    func bind(_ viewModel: ViewModel)
    static func preferredSize(fittingSize: CGSize, by viewModel: ViewModel) -> CGSize
}
