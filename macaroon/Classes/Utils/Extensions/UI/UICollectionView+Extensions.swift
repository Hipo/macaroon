// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension UICollectionView {
    public func register(_ someClass: (UICollectionViewCell & ListIdentifiable).Type) {
        register(someClass, forCellWithReuseIdentifier: someClass.reuseIdentifier)
    }

    public func register(_ someClass: (UICollectionReusableView & ListIdentifiable).Type, forSupplementaryViewOfKind kind: String) {
        register(someClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: someClass.reuseIdentifier)
    }

    public func register(header someClass: (UICollectionReusableView & ListIdentifiable).Type) {
        register(someClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }

    public func register(footer someClass: (UICollectionReusableView & ListIdentifiable).Type) {
        register(someClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
}
