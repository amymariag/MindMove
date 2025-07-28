import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var motion: MotionManager

    var body: some View {
        VStack(spacing: 32) {
            StreakRing(progress: motion.streakProgress)
                .frame(width: 180, height: 180)
                .padding(.top, 40)

            Text("Current streak: \(motion.currentStreak) 🏆")
                .font(.title2)
                .bold()

            Button(action: { motion.resetStreak() }) {
                Label("Reset", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(LinearGradient(colors: [.mint.opacity(0.2), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom))
    }
}

struct StreakRing: View {
    let progress: Double // 0‒1

    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.2), lineWidth: 20)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AngularGradient(gradient: .init(colors: [.green, .yellow, .orange]), center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
            Text("\(Int(progress * 100))%")
                .font(.largeTitle.bold())
        }
    }
}
