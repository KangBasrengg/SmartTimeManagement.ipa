import Foundation
import UserNotifications

final class NotificationScheduler {
    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    }

    func scheduleTaskReminder(for task: PlannerTask) {
        scheduleReminder(
            id: task.id.uuidString,
            title: task.title,
            body: "Aktivitas dimulai sebentar lagi.",
            eventDate: task.startDate,
            offset: task.reminder
        )
    }

    func scheduleMeetingReminder(for meeting: Meeting, clientName: String) {
        scheduleReminder(
            id: meeting.id.uuidString,
            title: meeting.title,
            body: "Meeting dengan \(clientName) akan segera dimulai.",
            eventDate: meeting.startDate,
            offset: meeting.reminder
        )
    }

    private func scheduleReminder(id: String, title: String, body: String, eventDate: Date, offset: ReminderOffset) {
        let triggerDate = eventDate.addingTimeInterval(-offset.secondsBeforeEvent)
        guard triggerDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
