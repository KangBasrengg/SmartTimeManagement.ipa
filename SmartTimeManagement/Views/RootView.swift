import SwiftUI

struct RootView: View {
    @Bindable var store: PlannerStore

    var body: some View {
        TabView {
            DashboardView(store: store)
                .tabItem { Label("Dashboard", systemImage: "gauge.with.dots.needle.33percent") }

            PlannerView(store: store)
                .tabItem { Label("Planner", systemImage: "checklist") }

            CalendarView(store: store)
                .tabItem { Label("Calendar", systemImage: "calendar") }

            ClientsView(store: store)
                .tabItem { Label("Clients", systemImage: "person.2") }

            NotesView(store: store)
                .tabItem { Label("Notes", systemImage: "note.text") }
        }
        .tint(.brandPrimary)
    }
}
