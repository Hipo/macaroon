// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ListIdentifiable where Self: UICollectionReusableView {
    public static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionReusableView: ListIdentifiable { }
