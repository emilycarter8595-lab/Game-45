import SwiftUI

enum Tab: String, CaseIterable {
    case main = "Main"
    case movement = "Movement"
    case deadlines = "Deadlines"
    
    var iconName: String {
        switch self {
        case .main: return "IconTabMain"
        case .movement: return "IconTabMovement"
        case .deadlines: return "IconTabDeadlines"
        }
    }
}

struct MainView: View {
    @State private var selectedTab: Tab = .main
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .main:
                    DashboardView()
                case .movement:
                    MovementHistoryView()
                case .deadlines:
                    DeadlinesView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 60)
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(selectedTab == tab ? DesignSystem.Colors.black : DesignSystem.Colors.white)
                                    .frame(width: 40, height: 40)
                                
                                Image(tab.iconName)
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(DesignSystem.Colors.primary)
                                    .frame(width: 20, height: 20)
                            }
                            .frame(height: 40)
                            
                            Text(tab.rawValue)
                                .font(DesignSystem.Fonts.caption)
                                .foregroundStyle(DesignSystem.Colors.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(DesignSystem.Colors.primary)
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainView()
        .environment(Router())
        .environment(StorageService.shared)
}
