import Foundation
import Observation

@Observable
final class StorageService {
    var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.setValue(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        }
    }
    
    var selectedWarehouse: String {
        didSet {
            UserDefaults.standard.setValue(selectedWarehouse, forKey: Keys.selectedWarehouse)
        }
    }
    
    static let shared = StorageService()
    
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedWarehouse = "selectedWarehouse"
    }
    
    private init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)
        selectedWarehouse = UserDefaults.standard.string(forKey: Keys.selectedWarehouse) ?? "Warehouse A"
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}
