// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

/// <note>
/// The base protocol which includes the common styles in an application.
public protocol StyleGuide: StyleSheet {
    associatedtype Element

    subscript<T>(_ element: Element) -> T { get }
}
