// Copyright © Hipolabs. All rights reserved.

import Foundation

extension Locale {
    public static var preferred: Locale {
        let preferredLocalization = Bundle.main.preferredLocalizations.first
        return preferredLocalization.unwrap(Locale.init) ?? .current
    }
}
