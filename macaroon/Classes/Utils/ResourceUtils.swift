// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <mark>
/// Colors
public func rgb(
    _ red: CGFloat,
    _ green: CGFloat,
    _ blue: CGFloat
) -> UIColor {
    return rgba(
        red,
        green,
        blue, 1.0
    )
}

public func rgba(
    _ red: CGFloat,
    _ green: CGFloat,
    _ blue: CGFloat,
    _ alpha: CGFloat
) -> UIColor {
    return UIColor(
        red: red,
        green: green,
        blue: blue,
        alpha: min(1.0, max(0.0, alpha))
    )
}

public func col(
    _ named: String
) -> UIColor {
    guard let color = UIColor(named: named) else {
        mc_crash(.colorNotFound(named))
    }
    return color
}

extension String {
    public var color: UIColor {
        return col(self)
    }
}

extension RawRepresentable where RawValue == String {
    public var color: UIColor {
        return rawValue.color
    }
}

/// <mark>
/// Images
public func img(_ named: String) -> UIImage {
    guard let image = UIImage(named: named) else {
        mc_crash(.imageNotFound(named))
    }
    return image
}

extension String {
    public var image: UIImage {
        return img(self)
    }
}

extension RawRepresentable where RawValue == String {
    public var image: UIImage {
        return rawValue.image
    }
}

/// <mark>
/// Localization
extension String {
    public func localized(_ args: CVarArg...) -> String {
        return localized(
            args: args
        )
    }

    public func localized(args: [CVarArg]) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: args)
    }
}

extension RawRepresentable where RawValue == String {
    public func localized(_ args: CVarArg...) -> String {
        return localized(
            args: args
        )
    }

    public func localized(args: [CVarArg]) -> String {
        return rawValue.localized(
            args
        )
    }
}
