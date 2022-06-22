// Copyright © 2022 hipolabs. All rights reserved.

import Foundation
import UIKit

public protocol ToastUILayoutCalculating: AnyObject {
    func calculateInitialFrame(
        ofNextPresented nextView: UIView
    ) -> CGRect
    func calculateFinalFrame(
        ofNextPresented nextView: UIView
    ) -> CGRect

    func calculateFinalFrame(
        ofReplacingLastPresented lastView: UIView
    ) -> CGRect

    func calculateFinalFrame(
        ofDismissingLastPresented lastView: UIView
    ) -> CGRect
}
