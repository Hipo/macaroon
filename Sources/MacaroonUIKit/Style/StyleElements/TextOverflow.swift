// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextOverflow {
    var numberOfLines: Int { get }
    var lineBreakMode: NSLineBreakMode { get }
    var adjustFontSizeToFitWidth: Bool { get }
    var minimumScaleFactor: CGFloat { get }
}

extension TextOverflow {
    public static func singleLine(
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) -> TextOverflow {
        return SingleLineText(lineBreakMode: lineBreakMode)
    }

    public static func singleLineFitting(
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        minimumScaleFactor: CGFloat = 0.5
    ) -> TextOverflow {
        return SingleLineFittingText(lineBreakMode: lineBreakMode, minimumScaleFactor: minimumScaleFactor)
    }

    public static func multiline(
        numberOfLines: Int,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) -> TextOverflow {
        return MultilineText(numberOfLines: numberOfLines, lineBreakMode: lineBreakMode)
    }

    public static func fitting(
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> TextOverflow {
        return FittingText(lineBreakMode: lineBreakMode)
    }
}

public struct SingleLineText: TextOverflow {
    public let numberOfLines: Int
    public let lineBreakMode: NSLineBreakMode
    public let adjustFontSizeToFitWidth: Bool
    public let minimumScaleFactor: CGFloat

    public init(
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) {
        self.numberOfLines = 1
        self.lineBreakMode = lineBreakMode
        self.adjustFontSizeToFitWidth = false
        self.minimumScaleFactor = 0
    }
}

public struct SingleLineFittingText: TextOverflow {
    public let numberOfLines: Int
    public let lineBreakMode: NSLineBreakMode
    public let adjustFontSizeToFitWidth: Bool
    public let minimumScaleFactor: CGFloat

    public init(
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        minimumScaleFactor: CGFloat = 0.5
    ) {
        self.numberOfLines = 1
        self.lineBreakMode = lineBreakMode
        self.adjustFontSizeToFitWidth = true
        self.minimumScaleFactor = minimumScaleFactor
    }
}

public struct MultilineText: TextOverflow {
    public let numberOfLines: Int
    public let lineBreakMode: NSLineBreakMode
    public let adjustFontSizeToFitWidth: Bool
    public let minimumScaleFactor: CGFloat

    public init(
        numberOfLines: Int,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail
    ) {
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        self.adjustFontSizeToFitWidth = false
        self.minimumScaleFactor = 0
    }
}

public struct FittingText: TextOverflow {
    public let numberOfLines: Int
    public let lineBreakMode: NSLineBreakMode
    public let adjustFontSizeToFitWidth: Bool
    public let minimumScaleFactor: CGFloat

    public init(
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) {
        self.numberOfLines = 0
        self.lineBreakMode = lineBreakMode
        self.adjustFontSizeToFitWidth = false
        self.minimumScaleFactor = 0
    }
}
