// Copyright © 2019 hipolabs. All rights reserved.

import AVFoundation
import Foundation
import MacaroonUtils

/// <warning>
/// It has the starting point to have a controller object for the camera. It will be improved over
/// the time.
open class CameraController:
    NSObject,
    NotificationObserver {
    open weak var delegate: CameraControllerDelegate?

    public var notificationObservations: [NSObjectProtocol] = []

    public private(set) var permission: Permission

    public private(set) var videoInput: AVCaptureDeviceInput!
    public private(set) var photoOutput: AVCapturePhotoOutput!

    public private(set) var isRunning = false

    private var initError: Error?

    /// <note>
    /// Async the session-related tasks over this queue for the performance gain or other
    /// issues like multi-thread connections etc.. (Serial)
    public let sessionQueue: DispatchQueue

    public let session: AVCaptureSession
    public let configuration: CameraControllerConfiguration

    public init(
        sessionQueue: DispatchQueue,
        configuration: CameraControllerConfiguration = .init()
    ) {
        self.sessionQueue = sessionQueue
        self.configuration = configuration
        self.session = AVCaptureSession()
        self.permission = .undetermined

        super.init()

        prepareForUse()
    }

    deinit {
        if !session.isRunning {
            return
        }

        stopObservingNotifications()

        session.stopRunning()
    }

    open func prepareForUse() {
        checkPermission()
        configureSession()
    }

    open func configureSession() {
        sessionQueue.async {
            [weak self] in

            guard let self = self else {
                return
            }

            if !self.permission.isGranted {
                self.initError = .noPermission
                return
            }

            self.session.beginConfiguration()

            self.session.sessionPreset = .photo

            do {
                try self.addInputs()
                try self.addOutputs()
            } catch let error as Error {
                self.initError = error
            } catch let unexpectedError {
                self.initError = .missingCamera(underlyingError: unexpectedError)
            }

            self.session.commitConfiguration()
        }
    }

    open func addInputs() throws {
        do {
            let device = AVCaptureDevice.default(for: .video)

            guard let someDevice = device else {
                throw Error.missingInput()
            }

            let input = try AVCaptureDeviceInput(device: someDevice)

            if !session.canAddInput(input) {
                throw Error.missingInput()
            }

            session.addInput(input)

            videoInput = input
        } catch let error {
            throw Error.missingInput(underlyingError: error)
        }
    }

    open func addOutputs() throws {
        let output = AVCapturePhotoOutput()

        if !session.canAddOutput(output) {
            throw Error.missingOutput()
        }

        session.addOutput(output)

        photoOutput = output
    }

    open func startRunning() {
        sessionQueue.async {
            [weak self] in

            guard let self = self else {
                return
            }

            if let initError = self.initError {
                asyncMain(self) {
                    strongSelf in

                    strongSelf.delegate?.cameraController(
                        strongSelf,
                        didMalfunction: initError
                    )
                }

                return
            }

            if !self.permission.isGranted {
                asyncMain(self) {
                    strongSelf in

                    strongSelf.delegate?.cameraController(
                        strongSelf,
                        didMalfunction: .noPermission
                    )
                }

                return
            }

            self.startObservingNotifications()
            self.setSessionRunning(true)
        }
    }

    open func startObservingNotifications() {
        observe(
            notification: .AVCaptureSessionDidStartRunning,
            using: sessionDidStartRunning
        )
        observe(
            notification: .AVCaptureSessionDidStopRunning,
            using: sessionDidStopRunning
        )
        observe(
            notification: .AVCaptureSessionRuntimeError,
            using: sessionDidFailOnRuntime
        )
        observe(
            notification: .AVCaptureSessionWasInterrupted,
            using: sessionWasInterrupted
        )
        observe(
            notification: .AVCaptureSessionInterruptionEnded,
            using: sessionDidReturnFromInterruption
        )
    }

    open func sessionDidStartRunning(
        _ notification: Notification
    ) {
        asyncMain(self) {
            strongSelf in

            strongSelf.delegate?.cameraControllerDidStartRunning(strongSelf)
        }
    }

    open func sessionDidStopRunning(
        _ notification: Notification
    ) {
        asyncMain(self) {
            strongSelf in

            strongSelf.delegate?.cameraControllerDidStopRunning(strongSelf)
        }
    }

    open func sessionDidFailOnRuntime(
        _ notification: Notification
    ) {
        func notifyDelegate(error: Swift.Error?) {
            asyncMain(self) {
                strongSelf in

                strongSelf.delegate?.cameraController(
                    strongSelf,
                    didMalfunction: .failedOnRuntime(underlyingError: error)
                )
            }
        }

        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else {
            notifyDelegate(error: nil)
            return
        }

        switch error.code {
        case .mediaServicesWereReset:
            sessionQueue.async {
                if self.isRunning {
                    self.setSessionRunning(true)
                } else {
                    notifyDelegate(error: error)
                }
            }
        default:
            notifyDelegate(error: error)
        }
    }

    open func sessionWasInterrupted(
        _ notification: Notification
    ) {
        guard
            let reasonObj = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
            let reasonCode = reasonObj.integerValue,
            let reason = AVCaptureSession.InterruptionReason(rawValue: reasonCode)
        else {
            return
        }

        asyncMain(self) {
            strongSelf in

            strongSelf.delegate?.cameraController(
                strongSelf,
                wasInterrupted: reason
            )
        }
    }

    open func sessionDidReturnFromInterruption(
        _ notification: Notification
    ) {
        asyncMain(self) {
            strongSelf in

            strongSelf.delegate?.cameraControllerDidReturnFromInterruption(strongSelf)
        }
    }

    open func resumeRunningAfterInterruption() {
        sessionQueue.async {
            [weak self] in

            guard let self = self else {
                return
            }

            self.setSessionRunning(true)

            if self.session.isRunning {
                asyncMain(self) {
                    strongSelf in

                    strongSelf
                        .delegate?
                        .cameraControllerDidResumeRunningAfterInterruption(strongSelf)
                }
            } else {
                asyncMain(self) {
                    strongSelf in

                    strongSelf.delegate?.cameraController(
                        strongSelf,
                        didMalfunction: .unableToResumeAfterInterruption
                    )
                }
            }
        }
    }

    open func stopRunning() {
        sessionQueue.async {
            [weak self] in

            guard let self = self else {
                return
            }

            if !self.permission.isGranted {
                return
            }

            self.setSessionRunning(false)
            self.stopObservingNotifications()
        }
    }
}

extension CameraController {
    public func checkPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            permission = .granted
        case .notDetermined:
            requestPermission()
        default:
            permission = .notGranted
        }
    }

    public func requestPermission() {
        /// <note>
        /// The session related tasks will be suspended till the user decision. it assumes that
        /// it is the first thing to be called.
        sessionQueue.suspend()

        AVCaptureDevice.requestAccess(for: .video) {
            isGranted in

            self.permission = isGranted ? .granted : .notGranted
            self.sessionQueue.resume()
        }
    }
}

extension CameraController {
    public func setSessionRunning(
        _ isRunning: Bool
    ) {
        isRunning
            ? session.startRunning()
            : session.stopRunning()
        self.isRunning = session.isRunning
    }
}

extension CameraController {
    public enum Permission {
        case undetermined
        case granted
        case notGranted

        public var isGranted: Bool {
            switch self {
            case .granted: return true
            default: return false
            }
        }
    }

    public enum Error: Swift.Error {
        case noPermission
        case missingInput(underlyingError: Swift.Error? = nil)
        case missingOutput(underlyingError: Swift.Error? = nil)
        case missingCamera(underlyingError: Swift.Error? = nil)
        case failedOnRuntime(underlyingError: Swift.Error? = nil)
        case unableToResumeAfterInterruption
    }
}

public protocol CameraControllerDelegate: AnyObject {
    func cameraControllerDidStartRunning(
        _ cameraController: CameraController
    )
    func cameraControllerDidResumeRunningAfterInterruption(
        _ cameraController: CameraController
    )
    func cameraControllerDidStopRunning(
        _ cameraController: CameraController
    )
    func cameraController(
        _ cameraController: CameraController,
        wasInterrupted reason: AVCaptureSession.InterruptionReason
    )
    func cameraControllerDidReturnFromInterruption(
        _ cameraController: CameraController
    )
    func cameraController(
        _ cameraController: CameraController,
        didMalfunction error: CameraController.Error
    )
}
