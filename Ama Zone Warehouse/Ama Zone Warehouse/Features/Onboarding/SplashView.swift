import SwiftUI

struct SplashView: View {
    @Environment(Router.self) private var router
    @Environment(StorageService.self) private var storageService
    
    var body: some View {
        ZStack {
            Image("SplashBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(DesignSystem.Colors.white)
                        .frame(width: 256, height: 256)
                        .overlay(
                            Circle()
                                .stroke(DesignSystem.Colors.primary, lineWidth: 8)
                        )
                    
                    VStack(spacing: 16) {
                        Image("AppLogoIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 83, height: 82)
                        
                        Text("Ama: Zone\nWarehouse")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.primary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            if storageService.hasCompletedOnboarding {
                router.push(.home)
            } else {
                router.push(.onboarding)
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(Router())
        .environment(StorageService.shared)
}
