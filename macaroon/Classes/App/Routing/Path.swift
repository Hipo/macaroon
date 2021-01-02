// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

/// <note>
/// Identifies a single screen.
public protocol Path: Equatable {
    associatedtype SomePathSpecifier: PathSpecifier

    var specifier: SomePathSpecifier { get }
    var build: () -> ScreenRoutable? { get }

    static func instance(_ specifier: SomePathSpecifier) -> Self
    static func instance(_ identifier: String) -> Self
}

extension Path {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.specifier == rhs.specifier
    }
}

public protocol PathSpecifier: Equatable {
    /// <note>
    ///  Should be unique for the different instances of the same path.
    var uniqueIdentifier: String { get }

    static func instance(_ identifier: String) -> Self
}

extension PathSpecifier {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uniqueIdentifier == rhs.uniqueIdentifier
    }
}

public enum AnchorPath {
    case initial
    case current
    case interim(ScreenRoutable)
}
