import SwiftUI

@main
struct MindMoveApp: App {
    @StateObject private var motionManager = MotionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(motionManager)
                .task { await motionManager.start() }
        }
    }
}
