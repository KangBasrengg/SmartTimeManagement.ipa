import SwiftUI

struct DashboardView: View {
    @Bindable var store: PlannerStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    statsGrid
                    nextMeeting
                    suggestions
                    conflicts
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Smart Time")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Agenda Hari Ini")
                .font(.title2.weight(.bold))
            Text("\(store.todayAgendaCount) aktivitas terjadwal, \(store.activeTaskCount) tugas aktif")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatTile(title: "Tugas aktif", value: "\(store.activeTaskCount)", icon: "checkmark.circle", tint: .brandPrimary)
            StatTile(title: "Meeting", value: "\(store.productivitySnapshot.meetingCount)", icon: "video", tint: .brandSecondary)
            StatTile(title: "Selesai", value: "\(Int(store.productivitySnapshot.completionRate * 100))%", icon: "chart.line.uptrend.xyaxis", tint: .green)
            StatTile(title: "Focus", value: "\(store.productivitySnapshot.focusHours, specifier: "%.1f")j", icon: "timer", tint: .orange)
        }
    }

    @ViewBuilder
    private var nextMeeting: some View {
        SectionPanel(title: "Meeting Berikutnya", icon: "clock") {
            if let meeting = store.nextMeeting {
                VStack(alignment: .leading, spacing: 8) {
                    Text(meeting.title).font(.headline)
                    Text(store.clientName(for: meeting))
                        .foregroundStyle(.secondary)
                    Label(meeting.startDate.formatted(date: .omitted, time: .shortened), systemImage: "calendar")
                        .font(.subheadline)
                }
            } else {
                EmptyState(text: "Belum ada meeting berikutnya.")
            }
        }
    }

    private var suggestions: some View {
        SectionPanel(title: "Smart Insight", icon: "sparkles") {
            VStack(spacing: 12) {
                ForEach(store.smartSuggestions) { suggestion in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(suggestion.title).font(.headline)
                        Text(suggestion.detail).font(.subheadline).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder
    private var conflicts: some View {
        if !store.conflicts.isEmpty {
            SectionPanel(title: "Konflik Jadwal", icon: "exclamationmark.triangle") {
                ForEach(store.conflicts) { conflict in
                    Text("\(conflict.firstTitle) bentrok dengan \(conflict.secondTitle)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
