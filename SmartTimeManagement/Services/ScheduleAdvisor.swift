import Foundation

struct ScheduleAdvisor {
    func detectConflicts(tasks: [PlannerTask], meetings: [Meeting]) -> [ScheduleConflict] {
        let events = tasks.map { ScheduledItem(title: $0.title, start: $0.startDate, end: $0.endDate) }
            + meetings.map { ScheduledItem(title: $0.title, start: $0.startDate, end: $0.endDate) }

        var conflicts: [ScheduleConflict] = []
        let sortedEvents = events.sorted { $0.start < $1.start }

        for index in sortedEvents.indices {
            let first = sortedEvents[index]
            for second in sortedEvents.dropFirst(index + 1) {
                guard second.start < first.end else { break }

                conflicts.append(
                    ScheduleConflict(
                        firstTitle: first.title,
                        secondTitle: second.title,
                        overlapStart: max(first.start, second.start),
                        overlapEnd: min(first.end, second.end)
                    )
                )
            }
        }

        return conflicts
    }

    func makeSuggestions(tasks: [PlannerTask], meetings: [Meeting], conflicts: [ScheduleConflict]) -> [ScheduleSuggestion] {
        var suggestions: [ScheduleSuggestion] = []
        let highPriorityTasks = tasks.filter { $0.priority == .high && !$0.isCompleted }
        let totalBusyHours = (tasks.reduce(0) { $0 + max($1.endDate.timeIntervalSince($1.startDate), 0) }
            + meetings.reduce(0) { $0 + max($1.endDate.timeIntervalSince($1.startDate), 0) }) / 3_600

        if let firstConflict = conflicts.first {
            suggestions.append(
                ScheduleSuggestion(
                    title: "Atur ulang jadwal bentrok",
                    detail: "\(firstConflict.firstTitle) dan \(firstConflict.secondTitle) memiliki overlap. Geser salah satunya ke slot kosong terdekat."
                )
            )
        }

        if highPriorityTasks.count >= 2 {
            suggestions.append(
                ScheduleSuggestion(
                    title: "Lindungi waktu fokus",
                    detail: "Ada \(highPriorityTasks.count) task high priority. Blok 90 menit tanpa meeting untuk menyelesaikan pekerjaan utama."
                )
            )
        }

        if totalBusyHours > 7 {
            suggestions.append(
                ScheduleSuggestion(
                    title: "Tambahkan buffer istirahat",
                    detail: "Agenda hari ini cukup padat. Sisipkan jeda 15-30 menit setelah meeting panjang."
                )
            )
        }

        if suggestions.isEmpty {
            suggestions.append(
                ScheduleSuggestion(
                    title: "Jadwal terlihat sehat",
                    detail: "Tidak ada konflik aktif. Mulai dari task prioritas tertinggi untuk menjaga momentum."
                )
            )
        }

        return suggestions
    }
}

private struct ScheduledItem {
    var title: String
    var start: Date
    var end: Date
}
