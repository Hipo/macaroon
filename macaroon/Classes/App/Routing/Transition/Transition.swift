// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol Transition {
    var completion: (() -> Void)? { get set }
    var animated: Bool { get }

    func playTransition(
        to screens: [ScreenRoutable],
        from fromScreen: ScreenRoutable
    )
}

extension Transition {
    public func completeTransition() {
        completion?()
    }
}

/// <note>
/// App determines a befitting transition for the current state.
public struct SelfTransition: Transition {
    public var completion: (() -> Void)?

    public let animated: Bool

    public init(
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        self.animated = animated
        self.completion = completion
    }

    public func playTransition(
        to screens: [ScreenRoutable],
        from fromScreen: ScreenRoutable
    ) { }
}
