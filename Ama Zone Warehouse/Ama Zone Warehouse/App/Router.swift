import SwiftUI
import Observation

@Observable
final class Router {
    var path = NavigationPath()
    
    func push(_ destination: Route) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case onboarding
    case home
    case zoneDetail(ZoneType)
    case addProduct(ZoneType)
    case detail(String)
    case settings
}
