// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ListSeparatorAdaptable: ListComposable {
    var separatorStyle: ListSeparatorStyle { get }
}

extension ListSeparatorAdaptable {
    public var separatorStyle: ListSeparatorStyle {
        return .none
    }
}

public enum ListSeparatorStyle {
    case none
    case single(Separator)
}
