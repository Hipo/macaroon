// Copyright © Hipolabs. All rights reserved.

import Foundation

public struct AnyEncodable:
    Encodable,
    Printable {
    public var debugDescription: String {
        return _describe()
    }

    private let _encode: (Encoder) throws -> Void
    private let _describe: () -> String

    public init<T: Encodable>(
        _ base: T
    ) {
        _encode = {
            encoder in

            var container = encoder.singleValueContainer()
            try container.encode(base)
        }
        _describe = {
            return "\(base)"
        }
    }

    public func encode(
        to encoder: Encoder
    ) throws {
        try _encode(encoder)
    }
}
