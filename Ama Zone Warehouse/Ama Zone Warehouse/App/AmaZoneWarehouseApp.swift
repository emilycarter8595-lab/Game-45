import SwiftUI
import SwiftData

@main
struct AmaZoneWarehouseApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Product.self, MovementRecord.self])
    }
}
