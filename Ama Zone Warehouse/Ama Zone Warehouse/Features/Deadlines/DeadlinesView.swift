import SwiftUI
import SwiftData

struct DeadlinesView: View {
    @Environment(StorageService.self) private var storageService
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Product.expirationDate, order: .forward) private var products: [Product]
    
    @State private var showingAlert = false
    
    var filteredProducts: [Product] {
        products.filter { product in
            product.warehouse == storageService.selectedWarehouse && product.expirationDate != nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Deadlines")
                    .font(DesignSystem.Fonts.title)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            HStack {
                Text("The expiration date is approaching.")
                    .font(DesignSystem.Fonts.body)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            
            HStack {
                Text("List")
                    .font(DesignSystem.Fonts.headline)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            if filteredProducts.isEmpty {
                ContentUnavailableView("No upcoming deadlines", systemImage: "calendar.badge.checkmark")
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredProducts) { product in
                            if let expDate = product.expirationDate {
                                DeadlineRow(
                                    name: product.name,
                                    date: expDate,
                                    daysRemaining: daysBetween(start: Date(), end: expDate)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
            
            Spacer()
            
            Button {
                showingAlert = true
            } label: {
                Text("Mark as implemented")
                    .font(DesignSystem.Fonts.button)
                    .foregroundStyle(DesignSystem.Colors.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(DesignSystem.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
            .alert("Marked as implemented", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
        }
        .background(DesignSystem.Colors.background)
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
    }
}

#Preview {
    DeadlinesView()
        .modelContainer(for: [Product.self, MovementRecord.self], inMemory: true)
        .environment(StorageService.shared)
}
