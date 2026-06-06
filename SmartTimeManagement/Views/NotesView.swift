import SwiftUI

struct NotesView: View {
    @Bindable var store: PlannerStore
    @State private var isAddingNote = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.notes.sorted { $0.createdAt > $1.createdAt }) { note in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.title).font(.headline)
                        Text(note.body)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                Button {
                    isAddingNote = true
                } label: {
                    Label("Tambah Note", systemImage: "square.and.pencil")
                }
            }
            .sheet(isPresented: $isAddingNote) {
                AddNoteView(store: store)
            }
        }
    }
}

private struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: PlannerStore
    @State private var title = ""
    @State private var bodyText = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Judul", text: $title)
                TextField("Isi catatan", text: $bodyText, axis: .vertical)
                    .lineLimit(5...10)
            }
            .navigationTitle("Tambah Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        store.addNote(title: title, body: bodyText)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
