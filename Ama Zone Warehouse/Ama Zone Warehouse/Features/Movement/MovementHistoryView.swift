import SwiftUI
import SwiftData

struct MovementHistoryView: View {
    @Environment(StorageService.self) private var storageService
    @Query(sort: \MovementRecord.date, order: .reverse) private var movements: [MovementRecord]
    @State private var selectedPeriod: Period = .month
    @State private var fromZone: String = ""
    @State private var toZone: String = ""
    @FocusState private var isInputFocused: Bool
    
    enum Period: String, CaseIterable {
        case today = "Today"
        case week = "Week"
        case month = "Month"
    }
    
    var filteredMovements: [MovementRecord] {
        movements.filter { movement in
            guard movement.warehouse == storageService.selectedWarehouse else { return false }
            
            let dateMatch: Bool
            let calendar = Calendar.current
            let now = Date()
            switch selectedPeriod {
            case .today:
                dateMatch = calendar.isDateInToday(movement.date)
            case .week:
                dateMatch = calendar.isDate(movement.date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                dateMatch = calendar.isDate(movement.date, equalTo: now, toGranularity: .month)
            }
            
            let fromText = movement.fromZone?.rawValue ?? "Arrival"
            let fromMatch = fromZone.isEmpty || fromText.localizedCaseInsensitiveContains(fromZone)
            let toMatch = toZone.isEmpty || movement.toZone.rawValue.localizedCaseInsensitiveContains(toZone)
            
            return dateMatch && fromMatch && toMatch
        }
    }
    
    var movesCount: Int { filteredMovements.count }
    
    var periodLabel: String {
        switch selectedPeriod {
        case .today: return "Today: "
        case .week: return "This week: "
        case .month: return "This month: "
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Movement")
                    .font(DesignSystem.Fonts.semiBold(size: 24))
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(periodLabel)
                    .font(DesignSystem.Fonts.semiBold(size: 24))
                    .foregroundStyle(DesignSystem.Colors.black)
                Text("\(movesCount) moves")
                    .font(DesignSystem.Fonts.semiBold(size: 24))
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Zones")
                            .font(DesignSystem.Fonts.semiBold(size: 16))
                            .foregroundStyle(DesignSystem.Colors.black)
                        
                        HStack(spacing: 12) {
                            TextField("Where?", text: $fromZone)
                                .font(DesignSystem.Fonts.medium(size: 12))
                                .focused($isInputFocused)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(DesignSystem.Colors.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Image("IconArrowSwap")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(DesignSystem.Colors.primary)
                                .frame(width: 18, height: 16)
                            
                            TextField("Where?", text: $toZone)
                                .font(DesignSystem.Fonts.medium(size: 12))
                                .focused($isInputFocused)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(DesignSystem.Colors.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Period")
                            .font(DesignSystem.Fonts.semiBold(size: 16))
                            .foregroundStyle(DesignSystem.Colors.black)
                        
                        HStack(spacing: 0) {
                            ForEach(Period.allCases, id: \.self) { period in
                                Button {
                                    withAnimation {
                                        selectedPeriod = period
                                    }
                                } label: {
                                    Text(period.rawValue)
                                        .font(DesignSystem.Fonts.semiBold(size: 14))
                                        .foregroundStyle(selectedPeriod == period ? DesignSystem.Colors.white : DesignSystem.Colors.black)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                        .background(selectedPeriod == period ? DesignSystem.Colors.primary : Color.clear)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(6)
                        .background(DesignSystem.Colors.white)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .frame(height: 52)
                    }
                    
                    LazyVStack(spacing: 12) {
                        ForEach(filteredMovements) { movement in
                            MovementRow(movement: movement)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .background(DesignSystem.Colors.backgroundDark)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
            }
        }
    }
}

#Preview {
    MovementHistoryView()
        .modelContainer(for: [Product.self, MovementRecord.self], inMemory: true)
        .environment(StorageService.shared)
}
