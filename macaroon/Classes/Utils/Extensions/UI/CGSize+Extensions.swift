// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

extension CGSize {
    public static var greatestFiniteMagnitude: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
}
