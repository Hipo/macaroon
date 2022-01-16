// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol UIInteraction {
    typealias Handler = () -> Void

    func activate(
        _ handler: @escaping Handler
    )
    func deactivate()
}
