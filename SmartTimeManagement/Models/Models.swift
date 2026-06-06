import Foundation

enum TaskPriority: String, CaseIterable, Codable, Identifiable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var id: String { rawValue }
}

enum ReminderOffset: String, CaseIterable, Codable, Identifiable {
    case fiveMinutes = "5 menit"
    case fifteenMinutes = "15 menit"
    case oneHour = "1 jam"
    case custom = "Custom"

    var id: String { rawValue }

    var secondsBeforeEvent: TimeInterval {
        switch self {
        case .fiveMinutes: 300
        case .fifteenMinutes: 900
        case .oneHour: 3_600
        case .custom: 1_800
        }
    }
}

struct PlannerTask: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date
    var priority: TaskPriority
    var reminder: ReminderOffset
    var isCompleted = false
}

struct Client: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var phone: String
    var email: String
    var company: String
    var notes: String
}

struct Meeting: Identifiable, Hashable, Codable {
    var id = UUID()
    var clientID: Client.ID
    var title: String
    var location: String
    var meetingLink: String
    var startDate: Date
    var endDate: Date
    var notes: String
    var outcome: String
    var followUp: String
    var reminder: ReminderOffset
    var isCompleted = false
}

struct NoteItem: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var body: String
    var createdAt = Date()
    var relatedMeetingID: Meeting.ID?
}

struct ProductivitySnapshot: Equatable {
    var completedTasks: Int
    var totalTasks: Int
    var meetingCount: Int
    var focusHours: Double

    var completionRate: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
}

struct ScheduleConflict: Identifiable, Equatable {
    var id = UUID()
    var firstTitle: String
    var secondTitle: String
    var overlapStart: Date
    var overlapEnd: Date
}

struct ScheduleSuggestion: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var detail: String
}
