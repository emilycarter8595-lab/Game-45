import Foundation
import SwiftData

@Model
final class Product {
    var id: UUID
    var name: String
    var sku: String
    var zone: ZoneType
    var warehouse: String = "Warehouse A"
    var arrivalDate: Date
    var expirationDate: Date?
    @Relationship(deleteRule: .cascade, inverse: \MovementRecord.product)
    var history: [MovementRecord]
    
    init(
        id: UUID = UUID(),
        name: String,
        sku: String,
        zone: ZoneType,
        warehouse: String = "Warehouse A",
        arrivalDate: Date = Date(),
        expirationDate: Date? = nil,
        history: [MovementRecord] = []
    ) {
        self.id = id
        self.name = name
        self.sku = sku
        self.zone = zone
        self.warehouse = warehouse
        self.arrivalDate = arrivalDate
        self.expirationDate = expirationDate
        self.history = history
    }
}

@Model
final class MovementRecord {
    var date: Date
    var fromZone: ZoneType?
    var toZone: ZoneType
    var warehouse: String = "Warehouse A"
    var product: Product?
    
    init(
        date: Date = Date(),
        fromZone: ZoneType? = nil,
        toZone: ZoneType,
        warehouse: String = "Warehouse A",
        product: Product? = nil
    ) {
        self.date = date
        self.fromZone = fromZone
        self.toZone = toZone
        self.warehouse = warehouse
        self.product = product
    }
}

enum ZoneType: String, Codable, CaseIterable, Identifiable {
    case coming = "Coming"
    case shipment = "Shipment"
    case defective = "Defective"
    case seasonal = "Seasonal"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .coming: return "IconZoneComing"
        case .shipment: return "IconZoneShipment"
        case .defective: return "IconZoneDefective"
        case .seasonal: return "IconZoneSeasonal"
        }
    }
}
