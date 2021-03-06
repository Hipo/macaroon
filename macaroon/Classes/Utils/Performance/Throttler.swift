// Copyright © 2019 hipolabs. All rights reserved.

import Foundation

public class Throttler {
    public typealias Task = () -> Void

    public let intervalInSeconds: TimeInterval

    private var nextTask: DispatchWorkItem?
    private var lastTaskRuntime: Date?

    private lazy var queue = DispatchQueue.global(qos: .userInitiated)

    public init(intervalInSeconds: TimeInterval) {
        self.intervalInSeconds = intervalInSeconds
    }

    public func performNext(_ task: @escaping Task) {
        nextTask?.cancel()

        let newTask = DispatchWorkItem { [weak self] in
            task()
            self?.lastTaskRuntime = Date()
        }
        queue.asyncAfter(deadline: DispatchTime.now() + calculateDelayInSecondsForNextTaskRuntime(), execute: newTask)

        nextTask = newTask
    }

    public func cancelAll() {
        nextTask?.cancel()
        nextTask = nil

        lastTaskRuntime = nil
    }

    private func calculateDelayInSecondsForNextTaskRuntime() -> TimeInterval {
        guard let lastTaskRuntime = lastTaskRuntime else {
            return 0.0
        }
        let timeFromLastTask = Date().timeIntervalSince(lastTaskRuntime)

        if timeFromLastTask > intervalInSeconds {
            return 0.0
        }
        return intervalInSeconds - timeFromLastTask
    }
}
