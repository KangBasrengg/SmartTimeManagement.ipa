import SwiftUI

struct ClientsView: View {
    @Bindable var store: PlannerStore
    @State private var isAddingClient = false
    @State private var selectedClientForMeeting: Client?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.clients) { client in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(client.name).font(.headline)
                                Text(client.company).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                selectedClientForMeeting = client
                            } label: {
                                Image(systemName: "calendar.badge.plus")
                            }
                            .buttonStyle(.bordered)
                        }
                        Text(client.email).font(.caption).foregroundStyle(.secondary)
                        if !client.notes.isEmpty {
                            Text(client.notes).font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Clients")
            .toolbar {
                Button {
                    isAddingClient = true
                } label: {
                    Label("Tambah Klien", systemImage: "person.badge.plus")
                }
            }
            .sheet(isPresented: $isAddingClient) {
                AddClientView(store: store)
            }
            .sheet(item: $selectedClientForMeeting) { client in
                ScheduleMeetingView(store: store, client: client)
            }
        }
    }
}

private struct AddClientView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: PlannerStore
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var company = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nama klien", text: $name)
                TextField("Nomor telepon", text: $phone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Perusahaan", text: $company)
                TextField("Catatan", text: $notes, axis: .vertical)
            }
            .navigationTitle("Tambah Klien")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        store.addClient(name: name, phone: phone, email: email, company: company, notes: notes)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct ScheduleMeetingView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: PlannerStore
    let client: Client
    @State private var title = "Meeting dengan klien"
    @State private var location = "Google Meet"
    @State private var link = ""
    @State private var startDate = Date().addingTimeInterval(3_600)
    @State private var endDate = Date().addingTimeInterval(7_200)
    @State private var notes = ""
    @State private var reminder: ReminderOffset = .fifteenMinutes

    var body: some View {
        NavigationStack {
            Form {
                Section(client.name) {
                    TextField("Judul meeting", text: $title)
                    TextField("Lokasi", text: $location)
                    TextField("Link Zoom/Meet", text: $link)
                    DatePicker("Mulai", selection: $startDate)
                    DatePicker("Selesai", selection: $endDate)
                    Picker("Reminder", selection: $reminder) {
                        ForEach(ReminderOffset.allCases) { reminder in
                            Text(reminder.rawValue).tag(reminder)
                        }
                    }
                    TextField("Catatan", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("Schedule Meeting")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        store.scheduleMeeting(
                            client: client,
                            title: title,
                            location: location,
                            meetingLink: link,
                            startDate: startDate,
                            endDate: endDate,
                            notes: notes,
                            reminder: reminder
                        )
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || endDate <= startDate)
                }
            }
        }
    }
}
