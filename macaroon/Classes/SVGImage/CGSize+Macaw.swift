// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Macaw
import UIKit

extension CGSize {
    func macaw_scaled() -> Size {
        return Size(w: Double(width.scaled()), h: Double(height.scaled()))
    }
}
