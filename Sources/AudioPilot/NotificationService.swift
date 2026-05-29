import Foundation
import UserNotifications

final class NotificationService: NSObject {
    private let center: UNUserNotificationCenter

    override init() {
        self.center = .current()
        super.init()
        center.delegate = self
    }

    func requestAuthorizationIfNeeded() {
        center.getNotificationSettings { [center] settings in
            guard settings.authorizationStatus == .notDetermined else {
                return
            }

            center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    func sendOutputChangedNotification(deviceName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Audio output changed"
        content.body = "Now playing through: \(deviceName)"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "audiopilot.audio-output-changed.\(UUID().uuidString)",
            content: content,
            trigger: nil
        )

        center.add(request)
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
