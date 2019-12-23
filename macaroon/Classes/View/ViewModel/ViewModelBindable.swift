// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

protocol ViewModelBindable {
    associatedtype SomeViewModel: ViewModel

    func bind(_ viewModel: SomeViewModel)
    static func preferredSize(fittingSize: CGSize, by viewModel: SomeViewModel) -> CGSize
}
