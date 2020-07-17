// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol FloatingPlaceholderTextInputViewStyleGuideConvertible: StyleGuideConvertible {
    func getInput() -> TextInputStyling
    func getEditingIndicator() -> Styling
    func getError() -> TextStyling
}
