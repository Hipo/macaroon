// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class NoDevTools: DevToolsConvertible {
    public required init() { }
}

public protocol DevToolsConvertible: AnyObject, Decodable, ExpressibleByNilLiteral {
    init()
}

extension DevToolsConvertible {
    /// <mark> ExpressibleByNilLIteral
    public init(nilLiteral: ()) {
        self.init()
    }
}

public protocol DevToolConvertible: AnyObject, Decodable {
    init()
}
