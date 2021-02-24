// Copyright © 2019 hipolabs. All rights reserved.

import AVFoundation
import Foundation

public struct CameraControllerConfiguration {
    public init() {}
}

extension AVCaptureVideoOrientation {
    public init?(
        _ deviceOrientation: UIDeviceOrientation?
    ) {
        guard let deviceOrientation = deviceOrientation else {
            self = .portrait
            return
        }

        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: self = .portrait
        }
    }

    public init?(
        _ interfaceOrientation: UIInterfaceOrientation?
    ) {
        guard let interfaceOrientation = interfaceOrientation else {
            self = .portrait
            return
        }

        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: self = .portrait
        }
    }
}
