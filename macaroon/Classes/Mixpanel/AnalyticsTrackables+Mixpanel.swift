// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import Mixpanel

extension AnalyticsTrackableMetadata {
    var mixpanel_analyticsMetadata: [String: MixpanelType] {
        var transformedMetadata: [String: MixpanelType] = [:]
        analyticsMetadata.forEach { transformedMetadata[$0.key.description] = $0.value as? MixpanelType }
        return transformedMetadata
    }
}
