// Copyright © Hipolabs. All rights reserved.

import Foundation
import UIKit

extension String {
    public subscript(
        safe index: Index?
    ) -> Character? {
        return
            index
                .unwrapConditionally { indices.contains($0) }
                .unwrap { self[$0] }
    }
}

extension String {
    public subscript(
        r: NSRange
    ) -> String {
        let start =
            index(
                startIndex,
                offsetBy: r.location
            )
        let end =
            index(
                start,
                offsetBy: r.length
            )

        return self[start..<end].string
    }

    public func withoutWhitespaces() -> String {
        return without(charactersIn: .whitespaces)
    }

    public func withoutNewlines() -> String {
        return without(charactersIn: .newlines)
    }

    public func withoutWhitespacesAndNewlines() -> String {
        return without(charactersIn: .whitespacesAndNewlines)
    }

    public func withoutLetters() -> String {
        return without(charactersIn: .letters)
    }

    public func withoutDigits() -> String {
        return without(charactersIn: .decimalDigits)
    }

    public func without(
        charactersIn string: String
    ) -> String {
        return without(charactersIn: CharacterSet(charactersIn: string))
    }

    public func without(
        charactersIn set: CharacterSet
    ) -> String {
        let allowedCharacters = unicodeScalars.filter { !set.contains($0) }
        return String(allowedCharacters)
    }

    public func without<T: StringProtocol>(
        _ string: T
    ) -> String {
        return
            replacingOccurrences(
                of: string,
                with: ""
            )
    }

    public func without(
        prefix: String
    ) -> String {
        return
            hasPrefix(prefix)
                ? dropFirst(prefix.count).string
                : self
    }

    public func without(
        suffix: String
    ) -> String {
        return
            hasSuffix(suffix)
                ? dropLast(suffix.count).string
                : self
    }

    public func replacingCharacters(
        in range: NSRange,
        with replacement: String
    ) -> String {
        return
            (self as NSString).replacingCharacters(
                in: range,
                with: replacement
            )
    }
}

extension String {
    public func containsCaseInsensitive(
        _ string: String
    ) -> Bool {
        return
            range(
                of: string,
                options: .caseInsensitive
            ) != nil
    }

    public func containsOnlyLetters() -> Bool {
        return containsCharacters(in: .letters)
    }

    public func containsOnlyDigits() -> Bool {
        return containsCharacters(in: .decimalDigits)
    }

    public func containsCharacters(
        in allowedCharacterSet: CharacterSet
    ) -> Bool {
        return rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
    }
}

extension String {
    public func copyToClipboard() {
        UIPasteboard.general.string = self
    }
}

extension String {
    public static var unavailable: String {
        return "<unavailable>"
    }

    public static var null: String {
        return "<nil>"
    }
}

extension Substring {
    public var string: String {
        return String(self)
    }
}

extension Optional where Wrapped == String {
    public var someString: String {
        return self ?? ""
    }
}
