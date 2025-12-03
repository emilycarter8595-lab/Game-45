import SwiftUI

struct ZoneCard: View {
    let title: String
    let count: Int
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                Circle()
                    .fill(DesignSystem.Colors.secondary)
                    .frame(width: 140, height: 140)
                    .offset(x: -30, y: -30)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(iconName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(width: 32, height: 32)
                            .padding(.leading, 12)
                            .padding(.top, 12)
                        
                        Spacer()
                        
                        Text("\(count)")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.secondary)
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(title)
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.secondary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundStyle(DesignSystem.Colors.primary)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .frame(height: 160)
            .background(DesignSystem.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large))
            .clipped()
        }
    }
}

#Preview {
    ZStack {
        DesignSystem.Colors.background
        ZoneCard(title: "Coming", count: 8, iconName: "IconZoneComing", action: {})
            .frame(width: 170)
    }
}
