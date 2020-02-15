// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListReusable: AnyObject {
    func prepareForReuse()
}

extension ListReusable {
    public func prepareForReuse() { }
}

extension UIView: ListReusable { }
