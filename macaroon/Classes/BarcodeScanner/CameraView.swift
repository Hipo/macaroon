// Copyright © 2019 hipolabs. All rights reserved.

import AVFoundation
import Foundation
import UIKit

open class CameraView: UIView {
    open override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    public var session: AVCaptureSession? {
        get { previewLayer.session }
        set { previewLayer.session = newValue }
    }

    public var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    public override init(
        frame: CGRect
    ) {
        super.init(
            frame: frame
        )

        previewLayer.videoGravity = .resizeAspectFill
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraView {
    public func adjustOrientation() {
        guard let connection = previewLayer.connection else {
            return
        }

        connection.videoOrientation =
            AVCaptureVideoOrientation(UIDevice.current.orientation) ?? .portrait
    }
}
