// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public let UIViewNoConstraintMetric: CGFloat = -999999.0

public protocol Layout {
    var edgesMetric: LayoutEdgesMetric { get }
    var sizeMetric: LayoutSizeMetric { get }
    var centerMetric: LayoutCenterMetric { get }
    var baselineMetric: LayoutMetric { get }
}

extension Layout {
    public var edgesMetric: LayoutEdgesMetric {
        return nil
    }
    public var sizeMetric: LayoutSizeMetric {
        return nil
    }
    public var centerMetric: LayoutCenterMetric {
        return nil
    }
    public var baselineMetric: LayoutMetric {
        return nil
    }
}
