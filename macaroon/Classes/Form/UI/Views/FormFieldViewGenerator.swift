// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol FormFieldViewGenerator: AnyObject {
    func makeFieldView(for field: FormField) -> FormFieldView?
}
