//  Created by Michał Kozik on 10/02/2023.

import Combine
import Foundation

class ChessClock: ObservableObject {

    // MARK: ---------------- Public interface ----------------

    @Published var firstTimerIsActive: Bool
    @Published var firstTimerElapsedTime: TimeInterval

    @Published var secondTimerIsActive: Bool
    @Published var secondTimerElapsedTime: TimeInterval

    init(seconds: Int) {
        firstTimer = CountdownTimer(isActive: false, startingTime: seconds)
        secondTimer = CountdownTimer(isActive: false, startingTime: seconds)

        firstTimerIsActive = firstTimer.getActiveStatus()
        firstTimerElapsedTime = firstTimer.getElapsedTime()

        secondTimerIsActive = secondTimer.getActiveStatus()
        secondTimerElapsedTime = secondTimer.getElapsedTime()
    }

    func firstTimerTap() -> Void {
        let timestamp = Date()
        if bothTimersAreInactive() {
            activateSecondTimer(with: timestamp)
        }
        else if firstTimerIsActive {
            deactivateFirstTimer(with: timestamp)
            activateSecondTimer(with: timestamp)
        }
    }

    func secondTimerTap() -> Void {
        let timestamp = Date()
        if bothTimersAreInactive() {
            activateFirstTimer(with: timestamp)
        }
        else if secondTimerIsActive {
            deactivateSecondTimer(with: timestamp)
            activateFirstTimer(with: timestamp)
        }
    }


    // MARK: ---------------- Private internals ----------------
    private let firstTimer: CountdownTimer
    private let secondTimer: CountdownTimer
    private var timer: Cancellable?

    private func bothTimersAreInactive() -> Bool {
        return !firstTimerIsActive && !secondTimerIsActive
    }

    private func activateFirstTimer(with timestamp: Date) {
        firstTimer.activate(with: timestamp)
        firstTimerIsActive = firstTimer.getActiveStatus()  // fixme: ugly update, can't republish?
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.firstTimerElapsedTime = self.firstTimer.updateAndGetElapsedTime(with: Date())
        }
    }

    private func deactivateFirstTimer(with timestamp: Date) {
        timer?.cancel()
        firstTimerElapsedTime = firstTimer.deactivateAndGetElapsedTime(with: timestamp)
        firstTimerIsActive = firstTimer.getActiveStatus()   // fixme: ugly update, can't republish?
    }

    private func activateSecondTimer(with timestamp: Date) {
        secondTimer.activate(with: timestamp)
        secondTimerIsActive = secondTimer.getActiveStatus()   // fixme: ugly update, can't republish?
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.secondTimerElapsedTime = self.secondTimer.updateAndGetElapsedTime(with: Date())
            }
    }

    private func deactivateSecondTimer(with timestamp: Date) {
        timer?.cancel()
        secondTimerElapsedTime = secondTimer.deactivateAndGetElapsedTime(with: timestamp)
        secondTimerIsActive = secondTimer.getActiveStatus()   // fixme: ugly update, can't republish?
    }

    class CountdownTimer {
        private var isActive: Bool = false
        private var elapsedTime: TimeInterval = 10
        private var activationTimestamps: [Date] = []
        private var dactivationTimestamps: [Date] = []
        private var lastUpdateTimestamp: Date

        init(isActive: Bool, startingTime elapsedTime: Int) {
            self.isActive = isActive
            self.elapsedTime = TimeInterval(elapsedTime)
            self.lastUpdateTimestamp = Date()
        }

        func activate(with timestamp: Date) -> Void {
            // todo: what should happen if isActive is already true? nothing, throw exception...
            isActive = true
            activationTimestamps.append(timestamp)
            lastUpdateTimestamp = timestamp
        }

        func deactivateAndGetElapsedTime(with timestamp: Date) -> TimeInterval {
            isActive = false
            dactivationTimestamps.append(timestamp)
            return updateAndGetElapsedTime(with: timestamp)
        }

        func updateAndGetElapsedTime(with timestamp: Date) -> TimeInterval {
            let interval = timestamp - lastUpdateTimestamp
            elapsedTime = elapsedTime > interval ? elapsedTime - interval : 0
            lastUpdateTimestamp = timestamp
            return elapsedTime
        }

        func getActiveStatus() -> Bool {
            return isActive
        }

        func getElapsedTime() -> TimeInterval {
            return elapsedTime
        }
    }
}
