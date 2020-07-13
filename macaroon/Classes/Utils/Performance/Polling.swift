// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class Polling {
    public typealias Operation = () -> Void

    public private(set) var isRunning = false

    public var intervalInSeconds: TimeInterval {
        didSet {
            resume()
        }
    }

    private let timer: DispatchSourceTimer

    public init(
        intervalInSeconds: TimeInterval,
        operation: @escaping Operation
    ) {
        self.intervalInSeconds = intervalInSeconds

        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler(handler: operation)
        self.timer = timer
    }

    deinit {
        invalidate()
    }

    public func resume(immediately: Bool = true) {
        let delay = immediately ? 0.0 : intervalInSeconds

        timer.schedule(deadline: DispatchTime.now() + delay, repeating: intervalInSeconds)

        if isRunning {
            return
        }
        isRunning = true
        timer.resume()
    }

    public func pause() {
        if !isRunning {
            return
        }
        isRunning = false
        timer.suspend()
    }

    public func invalidate() {
        timer.setEventHandler { }
        timer.cancel()
        resume()
    }
}
