// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol LoadingIndicatorComposable: UIView {
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: LoadingIndicatorComposable { }
