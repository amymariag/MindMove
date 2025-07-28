import Foundation
import UserNotifications
import WatchKit

enum SedentaryNotifier {
    static func sendReminder() {
        #if os(iOS)
        sendLocalNotification()
        #endif
        WKInterfaceDevice.current().play(.success)
    }

    private static func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Move!"
        content.body  = "A quick stretch keeps the streak alive."
        content.sound = .default
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
