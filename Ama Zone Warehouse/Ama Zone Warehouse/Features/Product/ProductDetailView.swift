import SwiftUI
import SwiftData

struct ProductDetailView: View {
    @Environment(Router.self) private var router
    let productId: String
    @Query private var products: [Product]
    
    var product: Product? {
        products.first { $0.id.uuidString == productId }
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
                
                Text("Product card")
                    .font(DesignSystem.Fonts.bold(size: 34))
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            if let product = product {
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(DesignSystem.Colors.secondary)
                                        .frame(width: 58, height: 58)
                                    
                                    Image(product.zone.iconName)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(DesignSystem.Colors.white)
                                        .frame(width: 32, height: 32)
                                }
                                
                                Text(product.name)
                                    .font(DesignSystem.Fonts.bold(size: 24))
                                    .foregroundStyle(DesignSystem.Colors.secondary)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Group {
                                    Text("Name: ")
                                        .font(DesignSystem.Fonts.bold(size: 16)) +
                                    Text(product.name)
                                        .font(DesignSystem.Fonts.regular(size: 16))
                                    
                                    Text("SKU: ")
                                        .font(DesignSystem.Fonts.bold(size: 16)) +
                                    Text(product.sku)
                                        .font(DesignSystem.Fonts.regular(size: 16))
                                    
                                    Text("Current Zone: ")
                                        .font(DesignSystem.Fonts.bold(size: 16)) +
                                    Text(product.zone.rawValue)
                                        .font(DesignSystem.Fonts.regular(size: 16))
                                    
                                    Text("Movement History:")
                                        .font(DesignSystem.Fonts.bold(size: 16))
                                }
                                .foregroundStyle(DesignSystem.Colors.black)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(product.history.sorted(by: { $0.date < $1.date }), id: \.date) { record in
                                        HStack(alignment: .top, spacing: 4) {
                                            Text("• \(record.date.formatted(Date.FormatStyle().year().month().day().locale(Locale(identifier: "ru_RU")))) — ")
                                                .font(DesignSystem.Fonts.regular(size: 16))
                                                .foregroundStyle(DesignSystem.Colors.black)
                                            
                                            if record.fromZone != nil {
                                                Text("moved to ")
                                                    .font(DesignSystem.Fonts.regular(size: 16))
                                                    .foregroundStyle(DesignSystem.Colors.black) +
                                                Text("\"\(record.toZone.rawValue)\"")
                                                    .font(DesignSystem.Fonts.bold(size: 16))
                                                    .foregroundStyle(DesignSystem.Colors.primary)
                                            } else {
                                                Text("added to ")
                                                    .font(DesignSystem.Fonts.regular(size: 16))
                                                    .foregroundStyle(DesignSystem.Colors.black) +
                                                Text("\"\(record.toZone.rawValue)\"")
                                                    .font(DesignSystem.Fonts.bold(size: 16))
                                                    .foregroundStyle(DesignSystem.Colors.primary)
                                            }
                                        }
                                        .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        .padding(24)
                        .background(DesignSystem.Colors.white)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            } else {
                ContentUnavailableView("Product not found", systemImage: "exclamationmark.triangle")
            }
            
            Spacer()
        }
        .background(DesignSystem.Colors.backgroundDark)
        .navigationBarHidden(true)
    }
}

#Preview {
    ProductDetailView(productId: "1")
        .environment(Router())
        .modelContainer(for: [Product.self, MovementRecord.self], inMemory: true)
}
