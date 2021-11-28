// Copyright © 2021 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol TextProvider {
    func load(
        in view: TextCustomizable
    )
}

public protocol StateTextProvider {
    func load(
        in view: StateTextCustomizable
    )
}

extension String:
    TextProvider,
    StateTextProvider {
    public func load(
        in view: TextCustomizable
    ) {
        view.mc_text = self
    }

    public func load(
        in view: StateTextCustomizable
    ) {
        view.mc_setText(
            self,
            for: .normal
        )
    }
}

extension NSAttributedString:
    TextProvider,
    StateTextProvider {
    public func load(
        in view: TextCustomizable
    ) {
        view.mc_attributedText = self
    }

    public func load(
        in view: StateTextCustomizable
    ) {
        view.mc_setAttributedText(
            self,
            for: .normal
        )
    }
}

public struct StateString: StateTextProvider {
    public typealias State = UIControl.State

    public let string: String
    public let state: State

    public init(
        string: String,
        state: State
    ) {
        self.string = string
        self.state = state
    }

    public func load(
        in view: StateTextCustomizable
    ) {
        view.mc_setText(
            string,
            for: state
        )
    }
}

public struct StateAttributedString: StateTextProvider {
    public typealias State = UIControl.State

    public let attributedString: NSAttributedString
    public let state: State

    public init(
        attributedString: NSAttributedString,
        state: State
    ) {
        self.attributedString = attributedString
        self.state = state
    }

    public func load(
        in view: StateTextCustomizable
    ) {
        view.mc_setAttributedText(
            attributedString,
            for: state
        )
    }
}

extension Array: StateTextProvider where Element: StateTextProvider {
    public func load(
        in view: StateTextCustomizable
    ) {
        forEach { $0.load(in: view) }
    }
}
