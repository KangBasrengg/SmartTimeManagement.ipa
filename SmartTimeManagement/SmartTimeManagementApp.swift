import SwiftUI

@main
struct SmartTimeManagementApp: App {
    @State private var store = PlannerStore.sample

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
