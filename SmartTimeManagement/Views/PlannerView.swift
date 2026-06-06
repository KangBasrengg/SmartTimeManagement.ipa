import SwiftUI

struct PlannerView: View {
    @Bindable var store: PlannerStore
    @State private var isAddingTask = false

    var body: some View {
        NavigationStack {
            List {
                Section("Aktivitas Hari Ini") {
                    ForEach(store.todayTasks) { task in
                        TaskRow(task: task) {
                            store.toggleTask(task)
                        }
                    }
                }
            }
            .navigationTitle("Daily Planner")
            .toolbar {
                Button {
                    isAddingTask = true
                } label: {
                    Label("Tambah Aktivitas", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(store: store)
            }
        }
    }
}

private struct TaskRow: View {
    let task: PlannerTask
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? Color.brandSecondary : Color.secondary)
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .strikethrough(task.isCompleted)
                    Text("\(task.startDate.formatted(date: .omitted, time: .shortened)) - \(task.endDate.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                PriorityPill(priority: task.priority)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: PlannerStore
    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3_600)
    @State private var priority: TaskPriority = .medium
    @State private var reminder: ReminderOffset = .fifteenMinutes

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nama aktivitas", text: $title)
                DatePicker("Mulai", selection: $startDate)
                DatePicker("Selesai", selection: $endDate)
                Picker("Prioritas", selection: $priority) {
                    ForEach(TaskPriority.allCases) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                Picker("Reminder", selection: $reminder) {
                    ForEach(ReminderOffset.allCases) { reminder in
                        Text(reminder.rawValue).tag(reminder)
                    }
                }
            }
            .navigationTitle("Tambah Aktivitas")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        store.addTask(title: title, startDate: startDate, endDate: endDate, priority: priority, reminder: reminder)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || endDate <= startDate)
                }
            }
        }
    }
}
