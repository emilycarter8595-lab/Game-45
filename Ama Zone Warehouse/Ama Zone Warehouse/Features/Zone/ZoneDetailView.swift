import SwiftUI
import SwiftData

struct ZoneDetailView: View {
    @Environment(Router.self) private var router
    @Environment(StorageService.self) private var storageService
    @Environment(\.modelContext) private var modelContext
    @Query private var allProducts: [Product]
    
    let zone: ZoneType
    
    @State private var isSelectionMode = false
    @State private var selectedProductIds: Set<UUID> = []
    @State private var showMoveConfirmation = false
    @State private var targetZone: ZoneType?
    
    var products: [Product] {
        allProducts.filter { product in
            product.zone == zone && product.warehouse == storageService.selectedWarehouse
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if isSelectionMode {
                        isSelectionMode = false
                        selectedProductIds.removeAll()
                    } else {
                        router.pop()
                    }
                } label: {
                    Image("IconBack")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                
                Spacer()
                
                Text(zone.rawValue)
                    .font(DesignSystem.Fonts.title)
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            HStack {
                Text("List of products")
                    .font(DesignSystem.Fonts.headline)
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Spacer()
                
                if isSelectionMode {
                    Text("\(selectedProductIds.count) selected")
                        .font(DesignSystem.Fonts.body)
                        .foregroundStyle(DesignSystem.Colors.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(products) { product in
                        HStack {
                            if isSelectionMode {
                                Image(systemName: selectedProductIds.contains(product.id) ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(DesignSystem.Colors.primary)
                                    .onTapGesture {
                                        toggleSelection(for: product.id)
                                    }
                            }
                            
                            ProductRow(product: product)
                                .onTapGesture {
                                    if isSelectionMode {
                                        toggleSelection(for: product.id)
                                    } else {
                                        router.push(.detail(product.id.uuidString))
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                if isSelectionMode {
                    Button {
                        showMoveConfirmation = true
                    } label: {
                        Text("Move to...")
                            .font(DesignSystem.Fonts.button)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(selectedProductIds.isEmpty ? DesignSystem.Colors.textSecondary : DesignSystem.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
                    }
                    .disabled(selectedProductIds.isEmpty)
                } else {
                    Button {
                        router.push(.addProduct(zone))
                    } label: {
                        Text("Add product")
                            .font(DesignSystem.Fonts.button)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
                    }
                    
                    Button {
                        isSelectionMode = true
                    } label: {
                        Text("Move selected")
                            .font(DesignSystem.Fonts.button)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(DesignSystem.Colors.background)
        .navigationBarHidden(true)
        .confirmationDialog("Select destination zone", isPresented: $showMoveConfirmation, titleVisibility: .visible) {
            ForEach(ZoneType.allCases) { zoneType in
                if zoneType != zone {
                    Button(zoneType.rawValue) {
                        moveSelectedProducts(to: zoneType)
                    }
                }
            }
        }
    }
    
    private func toggleSelection(for id: UUID) {
        if selectedProductIds.contains(id) {
            selectedProductIds.remove(id)
        } else {
            selectedProductIds.insert(id)
        }
    }
    
    private func moveSelectedProducts(to newZone: ZoneType) {
        let productsToMove = allProducts.filter { selectedProductIds.contains($0.id) }
        
        for product in productsToMove {
            let oldZone = product.zone
            product.zone = newZone
            
            let record = MovementRecord(
                date: Date(),
                fromZone: oldZone,
                toZone: newZone,
                warehouse: storageService.selectedWarehouse,
                product: product
            )
            
            product.history.append(record)
        }
        
        try? modelContext.save()
        
        isSelectionMode = false
        selectedProductIds.removeAll()
    }
}

#Preview {
    ZoneDetailView(zone: .coming)
        .modelContainer(for: [Product.self, MovementRecord.self], inMemory: true)
        .environment(Router())
        .environment(StorageService.shared)
}
