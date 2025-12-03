import SwiftUI

struct MovementRow: View {
    let movement: MovementRecord
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateFormatter.string(from: movement.date))
                .font(DesignSystem.Fonts.semiBold(size: 12))
                .foregroundStyle(DesignSystem.Colors.secondary)
            
            Text(movementText)
                .font(DesignSystem.Fonts.medium(size: 14))
                .foregroundStyle(DesignSystem.Colors.black)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 71)
        .background(DesignSystem.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var movementText: String {
        let productName = movement.product?.name ?? "Unknown Item"
        let from = movement.fromZone?.rawValue ?? "Arrival"
        let to = movement.toZone.rawValue
        return "\(productName): \(from) → \(to)"
    }
}

