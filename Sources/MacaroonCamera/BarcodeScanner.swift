// Copyright © 2019 hipolabs. All rights reserved.

import AVFoundation
import Foundation

open class BarcodeScanner:
    CameraController,
    AVCaptureMetadataOutputObjectsDelegate {
    open override var delegate: CameraControllerDelegate? {
        didSet { _delegate = delegate as? BarcodeScannerDelegate }
    }

    private(set) var metadataOutput: AVCaptureMetadataOutput!

    private weak var _delegate: BarcodeScannerDelegate?

    open override func addOutputs() throws {
        let output = AVCaptureMetadataOutput()

        if !session.canAddOutput(output) {
            throw Error.missingOutput()
        }

        session.addOutput(output)

        output.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        output.setMetadataObjectsDelegate(
            self,
            queue: .main
        )

        self.metadataOutput = output
    }

    /// <mark>
    /// AVCaptureMetadataOutputObjectsDelegate
    open func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        setSessionRunning(false)

        guard
            let foundMetadataObject = metadataObjects.first,
            let readableMetadataObject = foundMetadataObject as? AVMetadataMachineReadableCodeObject,
            let barcode = readableMetadataObject.stringValue
        else {
            return
        }

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        _delegate?.barcodeScanner(
            self,
            didReadBarcode: barcode
        )
    }
}

extension BarcodeScanner {
    public func boundScanningRect(
        to rect: CGRect,
        in previewLayer: AVCaptureVideoPreviewLayer
    ) {
        if !session.isRunning {
            return
        }

        metadataOutput.rectOfInterest =
            previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }
}

public protocol BarcodeScannerDelegate: CameraControllerDelegate {
    func barcodeScanner(
        _ scanner: BarcodeScanner,
        didReadBarcode barcodeNumber: String
    )
}
