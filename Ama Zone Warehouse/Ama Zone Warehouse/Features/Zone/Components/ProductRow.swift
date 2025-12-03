import SwiftUI

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.secondary)
                    .frame(width: 36, height: 36)
                
                Image(product.zone.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(DesignSystem.Colors.white)
                    .frame(width: 20, height: 20)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(product.name)
                        .font(DesignSystem.Fonts.body)
                        .fontWeight(.bold)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                    
                    Spacer()
                    
                    Text(product.sku)
                        .font(DesignSystem.Fonts.body)
                        .foregroundStyle(DesignSystem.Colors.primary)
                }
                
                if let expDate = product.expirationDate {
                    Text("until \(expDate.formatted(date: .numeric, time: .omitted))")
                        .font(DesignSystem.Fonts.caption)
                        .foregroundStyle(DesignSystem.Colors.textMuted)
                }
            }
        }
        .padding(16)
        .background(DesignSystem.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
    }
}

