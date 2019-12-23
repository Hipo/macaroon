// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

extension String {
    public func attributed(_ args: NSAttributedString.Args...) -> NSAttributedString {
        return NSAttributedString(string: self, args: args)
    }
}
