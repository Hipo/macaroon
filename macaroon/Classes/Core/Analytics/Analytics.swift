// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class NoAnalytics: AnalyticsConvertible {
    public required init() { }
}

public protocol AnalyticsConvertible: AnyObject, Decodable, ExpressibleByNilLiteral {
    init()
}

extension AnalyticsConvertible {
    /// <mark> ExpressibleByNilLIteral
    public init(nilLiteral: ()) {
        self.init()
    }
}
