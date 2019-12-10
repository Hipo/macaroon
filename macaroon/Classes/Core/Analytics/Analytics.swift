// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class NoAnalytics: AnalyticsConvertible {
    /// <mark> ExpressibleByNilLIteral
    public required init(nilLiteral: ()) { }
}

public protocol AnalyticsConvertible: AnyObject, Decodable, ExpressibleByNilLiteral { }
