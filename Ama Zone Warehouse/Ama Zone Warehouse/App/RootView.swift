import SwiftUI

struct RootView: View {
    @State private var router = Router()
    @State private var storageService = StorageService.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            SplashView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(router)
        .environment(storageService)
    }
    
    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .onboarding:
            OnboardingView()
                .navigationBarBackButtonHidden()
        case .home:
            MainView()
                .navigationBarBackButtonHidden()
        case .zoneDetail(let zone):
            ZoneDetailView(zone: zone)
                .navigationBarBackButtonHidden()
        case .addProduct(let zone):
            AddProductView(initialZone: zone)
                .navigationBarBackButtonHidden()
        case .detail(let id):
            ProductDetailView(productId: id)
                .navigationBarBackButtonHidden()
        case .settings:
            Text("Settings View")
        }
    }
}

