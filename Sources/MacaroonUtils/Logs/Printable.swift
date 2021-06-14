// Copyright © Hipolabs. All rights reserved.

import Foundation

public typealias DebugPrintable = CustomDebugStringConvertible
public typealias Printable = CustomStringConvertible & DebugPrintable

extension CustomDebugStringConvertible where Self: RawRepresentable, Self.RawValue == String {
    public var debugDescription: String {
        return rawValue
    }
}

extension CustomStringConvertible where Self: CustomDebugStringConvertible {
    public var description: String {
        return debugDescription
    }
}
