// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public func mc_crash(_ error: Error) -> Never {
    crash(error)
}

public func crash(_ error: ErrorConvertible) -> Never {
    fatalError(error.localizedDescription)
}
