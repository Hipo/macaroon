// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListSeparatorAdaptable: UICollectionViewCell {
    static var separatorStyle: ListSeparatorStyle { get }
}

extension ListSeparatorAdaptable {
    public static var separatorStyle: ListSeparatorStyle {
        return .none
    }
}

public enum ListSeparatorStyle {
    case none
    case single(Separator, margin: CGFloat = 0.0)

    var margin: CGFloat {
        switch self {
        case .none:
            return 0.0
        case .single(let separator, let margin):
            return separator.size + margin
        }
    }
}
