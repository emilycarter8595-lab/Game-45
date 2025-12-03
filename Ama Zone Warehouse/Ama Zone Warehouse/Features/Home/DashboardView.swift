import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(Router.self) private var router
    @Environment(StorageService.self) private var storageService
    @Query private var products: [Product]
    
    private func count(for zone: ZoneType) -> Int {
        products.filter { $0.zone == zone && $0.warehouse == storageService.selectedWarehouse }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(storageService.selectedWarehouse)
                    .font(DesignSystem.Fonts.title)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                
                Spacer()
                
                Menu {
                    Button("Warehouse A") {
                        storageService.selectedWarehouse = "Warehouse A"
                    }
                    Button("Warehouse B") {
                        storageService.selectedWarehouse = "Warehouse B"
                    }
                    Button("Warehouse C") {
                        storageService.selectedWarehouse = "Warehouse C"
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(storageService.selectedWarehouse)
                            .font(DesignSystem.Fonts.caption)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        ZStack {
                            Circle()
                                .fill(DesignSystem.Colors.primary)
                                .frame(width: 20, height: 20)
                            
                            Image("IconChevronDown")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(DesignSystem.Colors.white)
                                .frame(width: 10, height: 6)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(DesignSystem.Colors.cardBackground)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ZoneCard(
                    title: "Coming",
                    count: count(for: .coming),
                    iconName: "IconZoneComing",
                    action: { router.push(.zoneDetail(.coming)) }
                )
                
                ZoneCard(
                    title: "Shipment",
                    count: count(for: .shipment),
                    iconName: "IconZoneShipment",
                    action: { router.push(.zoneDetail(.shipment)) }
                )
                
                ZoneCard(
                    title: "Defective",
                    count: count(for: .defective),
                    iconName: "IconZoneDefective",
                    action: { router.push(.zoneDetail(.defective)) }
                )
                
                ZoneCard(
                    title: "Seasonal",
                    count: count(for: .seasonal),
                    iconName: "IconZoneSeasonal",
                    action: { router.push(.zoneDetail(.seasonal)) }
                )
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Product.self, inMemory: true)
        .environment(Router())
        .environment(StorageService.shared)
}
