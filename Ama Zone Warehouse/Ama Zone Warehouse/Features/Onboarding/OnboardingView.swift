import SwiftUI

struct OnboardingView: View {
    @Environment(Router.self) private var router
    @Environment(StorageService.self) private var storageService
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        .init(
            image: "OnboardingTruckBg",
            title: "Take control of your warehouse.",
            subtitle: "Track items, zones, and expiration dates — all in one place."
        ),
        .init(
            image: "OnboardingShelvesBg",
            title: "Move items with one tap.",
            subtitle: "Switch zones instantly and keep a clean movement history."
        ),
        .init(
            image: "OnboardingAisleBg",
            title: "See every movement.",
            subtitle: "Monitor daily stats, zone activity, and expiration alerts."
        )
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<pages.count, id: \.self) { index in
                if index == currentPage {
                    Image(pages[index].image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
            }
            
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, DesignSystem.Colors.white.opacity(0.8), DesignSystem.Colors.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(pages[currentPage].title)
                        .font(DesignSystem.Fonts.title)
                        .foregroundStyle(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(pages[currentPage].subtitle)
                        .font(DesignSystem.Fonts.body)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Button {
                        nextPage()
                    } label: {
                        Text("Next")
                            .font(DesignSystem.Fonts.button)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .animation(.easeInOut, value: currentPage)
    }
    
    private func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }
    
    private func completeOnboarding() {
        storageService.completeOnboarding()
        router.push(.home)
    }
}

private struct OnboardingPage {
    let image: String
    let title: String
    let subtitle: String
}

#Preview {
    OnboardingView()
        .environment(Router())
        .environment(StorageService.shared)
}
