// Copyright © 2019 hipolabs. All rights reserved.

import AVFoundation
import Foundation
import UIKit

public struct CameraControllerConfiguration {
    public init() {}
}

extension AVCaptureVideoOrientation {
    public init?(
        _ deviceOrientation: UIDeviceOrientation?
    ) {
        switch deviceOrientation {
        case .some(.portrait): self = .portrait
        case .some(.portraitUpsideDown): self = .portraitUpsideDown
        case .some(.landscapeLeft): self = .landscapeRight
        case .some(.landscapeRight): self = .landscapeLeft
        default: self = .portrait
        }
    }

    public init?(
        _ interfaceOrientation: UIInterfaceOrientation?
    ) {
        switch interfaceOrientation {
        case .some(.portrait): self = .portrait
        case .some(.portraitUpsideDown): self = .portraitUpsideDown
        case .some(.landscapeLeft): self = .landscapeLeft
        case .some(.landscapeRight): self = .landscapeRight
        default: self = .portrait
        }
    }
}
