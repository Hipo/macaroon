// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class NoDevTools: DevToolsConvertible {
    /// <mark> ExpressibleByNilLiteral
    public required init(nilLiteral: ()) { }
}

public protocol DevToolsConvertible: AnyObject, Decodable, ExpressibleByNilLiteral { }

public protocol DevToolConvertible: AnyObject, Decodable, ExpressibleByNilLiteral { }
