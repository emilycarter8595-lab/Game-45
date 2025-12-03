import SwiftUI

struct DeadlineRow: View {
    let name: String
    let date: Date
    let daysRemaining: Int
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(DesignSystem.Fonts.headline)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            
            HStack(spacing: 4) {
                Text("expires")
                    .font(DesignSystem.Fonts.caption)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                
                Text(formattedDate)
                    .font(DesignSystem.Fonts.caption)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                
                if daysRemaining <= 3 && daysRemaining >= 0 {
                    Text("(in \(daysRemaining) days)")
                        .font(DesignSystem.Fonts.caption)
                        .foregroundStyle(DesignSystem.Colors.primary)
                } else if daysRemaining < 0 {
                    Text("(expired)")
                        .font(DesignSystem.Fonts.caption)
                        .foregroundStyle(DesignSystem.Colors.error)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
    }
}

#Preview {
    ZStack {
        DesignSystem.Colors.background
        DeadlineRow(name: "Test Product", date: Date(), daysRemaining: 2)
            .padding()
    }
}

