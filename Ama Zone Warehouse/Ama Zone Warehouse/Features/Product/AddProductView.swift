import SwiftUI
import SwiftData

struct AddProductView: View {
    @Environment(Router.self) private var router
    @Environment(StorageService.self) private var storageService
    @Environment(\.modelContext) private var modelContext
    let initialZone: ZoneType
    
    @State private var name: String = ""
    @State private var sku: String = ""
    @State private var selectedZone: ZoneType
    @State private var arrivalDate: Date = Date()
    @State private var expirationDate: Date = Date().addingTimeInterval(86400 * 30)
    
    private enum FocusField {
        case name
        case sku
    }
    @FocusState private var focusedField: FocusField?
    
    init(initialZone: ZoneType) {
        self.initialZone = initialZone
        _selectedZone = State(initialValue: initialZone)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    router.pop()
                } label: {
                    Image("IconBack")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                
                Spacer()
                
                Text("Add product")
                    .font(DesignSystem.Fonts.title)
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        TextField("", text: $name)
                            .focused($focusedField, equals: .name)
                            .padding()
                            .frame(height: 60)
                            .background(DesignSystem.Colors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = .name
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Item")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        TextField("", text: $sku)
                            .focused($focusedField, equals: .sku)
                            .padding()
                            .frame(height: 60)
                            .background(DesignSystem.Colors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = .sku
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Zone")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        Menu {
                            ForEach(ZoneType.allCases) { zone in
                                Button {
                                    selectedZone = zone
                                } label: {
                                    Text(zone.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedZone.rawValue)
                                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                                
                                Spacer()
                                
                                Image("IconChevronDown")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(DesignSystem.Colors.white)
                                    .frame(width: 10, height: 6)
                                    .padding(6)
                                    .background(DesignSystem.Colors.primary)
                                    .clipShape(Circle())
                            }
                            .padding()
                            .frame(height: 60)
                            .background(DesignSystem.Colors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Arrival Date")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        DatePicker("", selection: $arrivalDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(DesignSystem.Colors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expiration Date")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundStyle(DesignSystem.Colors.textPrimary)
                        
                        DatePicker("", selection: $expirationDate, displayedComponents: .date)
                            .labelsHidden()
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(DesignSystem.Colors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium))
                    }
                    
                    Button {
                        saveProduct()
                    } label: {
                        Text("Save")
                            .font(DesignSystem.Fonts.button)
                            .foregroundStyle(DesignSystem.Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(DesignSystem.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.extraLarge))
                    }
                    .disabled(name.isEmpty || sku.isEmpty)
                    .opacity(name.isEmpty || sku.isEmpty ? 0.6 : 1)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 16)
            }
            .scrollDismissesKeyboard(.interactively)
            
            Spacer()
        }
        .background(DesignSystem.Colors.background)
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
    
    private func saveProduct() {
        let newProduct = Product(
            name: name,
            sku: sku,
            zone: selectedZone,
            warehouse: storageService.selectedWarehouse,
            arrivalDate: arrivalDate,
            expirationDate: expirationDate
        )
        
        modelContext.insert(newProduct)
        
        let initialMovement = MovementRecord(
            date: Date(),
            fromZone: nil,
            toZone: selectedZone,
            warehouse: storageService.selectedWarehouse,
            product: newProduct
        )
        
        newProduct.history.append(initialMovement)
        
        try? modelContext.save()
        router.pop()
    }
}

#Preview {
    AddProductView(initialZone: .coming)
        .modelContainer(for: [Product.self, MovementRecord.self], inMemory: true)
        .environment(Router())
        .environment(StorageService.shared)
}
