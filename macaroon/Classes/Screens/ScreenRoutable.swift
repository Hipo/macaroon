// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ScreenRoutable {
    associatedtype SomeAppRouter: AppRouter

    var router: SomeAppRouter { get }
}
