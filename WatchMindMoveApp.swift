#if os(watchOS)
import SwiftUI

@main
struct WatchMindMoveApp: App {
    @StateObject private var motion = MotionManager()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environmentObject(motion)
                .task { await motion.start() }
        }
    }
}

struct WatchContentView: View {
    @EnvironmentObject private var motion: MotionManager

    var body: some View {
        VStack(spacing: 12) {
            ProgressView(value: motion.streakProgress)
                .progressViewStyle(.circular)
                .frame(width: 80, height: 80)
            Text("Streak \(motion.currentStreak)")
                .font(.headline)
        }
        .padding()
    }
}
#endif
