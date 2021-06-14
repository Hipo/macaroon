// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension NumberFormatter {
    public static var ordinal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }

    public static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
