import XCTest
@testable import SmartTimeManagement

final class SmartTimeManagementTests: XCTestCase {
    func testConflictDetectionFindsOverlappingTaskAndMeeting() {
        let start = Date(timeIntervalSince1970: 1_800_000_000)
        let end = start.addingTimeInterval(3_600)
        let client = Client(name: "Ari", phone: "", email: "", company: "", notes: "")
        let task = PlannerTask(title: "Deep work", startDate: start, endDate: end, priority: .high, reminder: .fifteenMinutes)
        let meeting = Meeting(
            clientID: client.id,
            title: "Client call",
            location: "Meet",
            meetingLink: "",
            startDate: start.addingTimeInterval(1_800),
            endDate: end.addingTimeInterval(1_800),
            notes: "",
            outcome: "",
            followUp: "",
            reminder: .fifteenMinutes
        )

        let conflicts = ScheduleAdvisor().detectConflicts(tasks: [task], meetings: [meeting])

        XCTAssertEqual(conflicts.count, 1)
        XCTAssertEqual(conflicts.first?.firstTitle, "Deep work")
        XCTAssertEqual(conflicts.first?.secondTitle, "Client call")
    }

    @MainActor
    func testStoreTracksProductivityAndActiveTasks() {
        let store = PlannerStore()
        let start = Date(timeIntervalSince1970: 1_800_000_000)

        store.addTask(
            title: "Proposal",
            startDate: start,
            endDate: start.addingTimeInterval(3_600),
            priority: .high,
            reminder: .fifteenMinutes
        )
        store.toggleTask(store.tasks[0])

        XCTAssertEqual(store.activeTaskCount, 0)
        XCTAssertEqual(store.productivitySnapshot.completedTasks, 1)
        XCTAssertEqual(store.productivitySnapshot.totalTasks, 1)
        XCTAssertEqual(store.productivitySnapshot.focusHours, 1)
    }

    func testSuggestionsFallbackWhenScheduleIsHealthy() {
        let suggestions = ScheduleAdvisor().makeSuggestions(tasks: [], meetings: [], conflicts: [])

        XCTAssertEqual(suggestions.first?.title, "Jadwal terlihat sehat")
    }
}
