import Foundation
import Combine
import CoreMotion
import HealthKit

@MainActor
final class MotionManager: ObservableObject {
    // MARK: ‑ Public state
    @Published var currentStreak: Int = 0
    @Published var streakProgress: Double = 0.0 // 0…1

    // MARK: ‑ Private helpers
    private let healthStore = HKHealthStore()
    private let motionMgr = CMMotionActivityManager()
    private var lastMoveDate = Date()
    private var timer: Timer?

    // Configuration
    private let sedentaryThreshold: TimeInterval = 25 * 60 // 25 minutes
    private let checkInterval: TimeInterval = 10            // seconds

    // MARK: API
    func start() async {
        await requestPermissions()
        startMotionUpdates()
        scheduleTimer()
    }

    func resetStreak() {
        currentStreak = 0
        streakProgress = 0
        lastMoveDate = Date()
    }

    // MARK: ‑ Permissions
    private func requestPermissions() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let readTypes: Set = [HKQuantityType.quantityType(forIdentifier: .stepCount)!]
        try? await healthStore.requestAuthorization(toShare: [], read: readTypes)
    }

    // MARK: ‑ Motion pipeline
    private func startMotionUpdates() {
        motionMgr.startActivityUpdates(to: .main) { [weak self] activity in
            guard let self, let activity else { return }
            if activity.walking || activity.running || activity.cycling || !activity.automotive {
                self.lastMoveDate = Date()
            }
        }
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { [weak self] _ in
            self?.evaluateSedentary()
        }
    }

    private func evaluateSedentary() {
        let sedentaryTime = Date().timeIntervalSince(lastMoveDate)
        streakProgress = min(sedentaryTime / sedentaryThreshold, 1)

        guard sedentaryTime >= sedentaryThreshold else { return }

        SedentaryNotifier.sendReminder()
        lastMoveDate = Date()
        currentStreak += 1
        streakProgress = 0
    }
}
