// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol LoadingIndicator: UIView {
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: LoadingIndicator { }
