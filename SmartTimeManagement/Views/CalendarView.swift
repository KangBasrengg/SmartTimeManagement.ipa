import SwiftUI

enum CalendarMode: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"

    var id: String { rawValue }
}

struct CalendarView: View {
    @Bindable var store: PlannerStore
    @State private var mode: CalendarMode = .daily

    var body: some View {
        NavigationStack {
            List {
                Picker("Mode", selection: $mode) {
                    ForEach(CalendarMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)

                Section("Task") {
                    ForEach(store.tasks.sorted { $0.startDate < $1.startDate }) { task in
                        CalendarEventRow(title: task.title, subtitle: task.priority.rawValue, date: task.startDate, tint: .brandPrimary)
                    }
                }

                Section("Meeting") {
                    ForEach(store.meetings.sorted { $0.startDate < $1.startDate }) { meeting in
                        CalendarEventRow(title: meeting.title, subtitle: store.clientName(for: meeting), date: meeting.startDate, tint: .brandSecondary)
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

private struct CalendarEventRow: View {
    let title: String
    let subtitle: String
    let date: Date
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(tint)
                .frame(width: 5)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).foregroundStyle(.secondary)
            }
            Spacer()
            Text(date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
