import Foundation
import Observation

@Observable
final class PlannerStore {
    var tasks: [PlannerTask]
    var clients: [Client]
    var meetings: [Meeting]
    var notes: [NoteItem]

    private let calendar: Calendar
    private let advisor: ScheduleAdvisor

    init(
        tasks: [PlannerTask] = [],
        clients: [Client] = [],
        meetings: [Meeting] = [],
        notes: [NoteItem] = [],
        calendar: Calendar = .current,
        advisor: ScheduleAdvisor = ScheduleAdvisor()
    ) {
        self.tasks = tasks
        self.clients = clients
        self.meetings = meetings
        self.notes = notes
        self.calendar = calendar
        self.advisor = advisor
    }

    var activeTaskCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    var nextMeeting: Meeting? {
        meetings
            .filter { !$0.isCompleted && $0.startDate >= Date() }
            .sorted { $0.startDate < $1.startDate }
            .first
    }

    var todayTasks: [PlannerTask] {
        tasks
            .filter { calendar.isDateInToday($0.startDate) }
            .sorted { $0.startDate < $1.startDate }
    }

    var todayMeetings: [Meeting] {
        meetings
            .filter { calendar.isDateInToday($0.startDate) }
            .sorted { $0.startDate < $1.startDate }
    }

    var todayAgendaCount: Int {
        todayTasks.count + todayMeetings.count
    }

    var productivitySnapshot: ProductivitySnapshot {
        let completed = tasks.filter(\.isCompleted).count
        let focusHours = tasks.reduce(0) { partial, task in
            partial + max(task.endDate.timeIntervalSince(task.startDate), 0) / 3_600
        }

        return ProductivitySnapshot(
            completedTasks: completed,
            totalTasks: tasks.count,
            meetingCount: meetings.count,
            focusHours: focusHours
        )
    }

    var conflicts: [ScheduleConflict] {
        advisor.detectConflicts(tasks: tasks, meetings: meetings)
    }

    var smartSuggestions: [ScheduleSuggestion] {
        advisor.makeSuggestions(tasks: tasks, meetings: meetings, conflicts: conflicts)
    }

    func addTask(title: String, startDate: Date, endDate: Date, priority: TaskPriority, reminder: ReminderOffset) {
        tasks.append(
            PlannerTask(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                startDate: startDate,
                endDate: endDate,
                priority: priority,
                reminder: reminder
            )
        )
    }

    func toggleTask(_ task: PlannerTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
    }

    func addClient(name: String, phone: String, email: String, company: String, notes: String) {
        clients.append(
            Client(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                phone: phone,
                email: email,
                company: company,
                notes: notes
            )
        )
    }

    func scheduleMeeting(
        client: Client,
        title: String,
        location: String,
        meetingLink: String,
        startDate: Date,
        endDate: Date,
        notes: String,
        reminder: ReminderOffset
    ) {
        meetings.append(
            Meeting(
                clientID: client.id,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                location: location,
                meetingLink: meetingLink,
                startDate: startDate,
                endDate: endDate,
                notes: notes,
                outcome: "",
                followUp: "",
                reminder: reminder
            )
        )
    }

    func completeMeeting(_ meeting: Meeting, outcome: String, followUp: String) {
        guard let index = meetings.firstIndex(where: { $0.id == meeting.id }) else { return }
        meetings[index].isCompleted = true
        meetings[index].outcome = outcome
        meetings[index].followUp = followUp
    }

    func addNote(title: String, body: String, relatedMeetingID: Meeting.ID? = nil) {
        notes.append(
            NoteItem(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                body: body,
                relatedMeetingID: relatedMeetingID
            )
        )
    }

    func clientName(for meeting: Meeting) -> String {
        clients.first { $0.id == meeting.clientID }?.name ?? "Klien"
    }
}

extension PlannerStore {
    static var sample: PlannerStore {
        let now = Date()
        let calendar = Calendar.current
        let client = Client(
            name: "Andi Wijaya",
            phone: "+62 812 0000 1122",
            email: "andi@example.com",
            company: "Wijaya Studio",
            notes: "Prioritas: website company profile."
        )

        return PlannerStore(
            tasks: [
                PlannerTask(
                    title: "Review proposal landing page",
                    startDate: calendar.date(byAdding: .hour, value: 1, to: now) ?? now,
                    endDate: calendar.date(byAdding: .hour, value: 2, to: now) ?? now,
                    priority: .high,
                    reminder: .fifteenMinutes
                ),
                PlannerTask(
                    title: "Follow up invoice Mei",
                    startDate: calendar.date(byAdding: .hour, value: 3, to: now) ?? now,
                    endDate: calendar.date(byAdding: .hour, value: 4, to: now) ?? now,
                    priority: .medium,
                    reminder: .oneHour
                )
            ],
            clients: [client],
            meetings: [
                Meeting(
                    clientID: client.id,
                    title: "Kickoff Website",
                    location: "Google Meet",
                    meetingLink: "https://meet.google.com/demo",
                    startDate: calendar.date(byAdding: .hour, value: 5, to: now) ?? now,
                    endDate: calendar.date(byAdding: .hour, value: 6, to: now) ?? now,
                    notes: "Bahas scope MVP dan timeline.",
                    outcome: "",
                    followUp: "",
                    reminder: .fifteenMinutes
                )
            ],
            notes: [
                NoteItem(title: "Ide produktivitas", body: "Blok waktu fokus 90 menit sebelum meeting klien.")
            ]
        )
    }
}
