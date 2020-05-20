// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public protocol ZendeskIdentity {
    var fullName: String? { get }
    var email: String? { get }
}
