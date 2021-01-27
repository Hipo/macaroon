// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public typealias BaseStyle<T: BaseStyleAttribute> = [T]

extension BaseStyle {
    public func mutate(
        by other: [Element]
    ) -> Self {
        /// <note>
        /// The modifier style overrides the attributes of the self style.
        let union = Set(other).union(Set(self))
        return Array(union)
    }
}

public protocol BaseStyleAttribute: Hashable {
    var id: String { get }

    static func backgroundColor(_ color: Color) -> Self
    static func tintColor(_ color: Color) -> Self
    static func border(_ border: Border) -> Self
    static func corner(_ corner: Corner) -> Self
    static func shadow(_ shadow: Shadow) -> Self
}

extension BaseStyleAttribute {
    public func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(id)
    }

    public static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        return lhs.id == rhs.id
    }
}

extension BaseStyleAttribute {
    static func getBackgroundColorAttributeId() -> String {
        return "backgroundColor"
    }

    static func getTintColorAttributeId() -> String {
        return "tintColor"
    }

    static func getBorderAttributeId() -> String {
        return "border"
    }

    static func getCornerAttributeId() -> String {
        return "corner"
    }

    static func getShadowAttributeId() -> String {
        return "shadow"
    }
}
