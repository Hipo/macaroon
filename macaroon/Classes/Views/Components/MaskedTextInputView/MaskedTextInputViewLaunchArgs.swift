// Copyright © 2019 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol MaskedTextInputViewStyleGuideConvertible: StyleGuideConvertible {
    func getMaskedTextInput() -> TextStyling
    func getTextInput() -> TextInputStyling
}
