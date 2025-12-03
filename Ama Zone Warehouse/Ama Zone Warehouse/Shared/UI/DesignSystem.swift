import SwiftUI

enum DesignSystem {
    enum Colors {
        static let background = Color(hex: "#F5F5F5")
        static let backgroundDark = Color(hex: "#E6E6E6")
        static let cardBackground = Color.white
        static let textPrimary = Color.black
        static let textSecondary = Color(hex: "#757575")
        static let textMuted = Color(hex: "#9E9E9E")
        static let primary = Color(hex: "#FF9900")
        static let secondary = Color(hex: "#0165f9")
        static let error = Color(hex: "#dc143c")
        static let white = Color.white
        static let black = Color.black
    }
    
    enum Fonts {
        static let title = Font.custom("Poppins-SemiBold", size: 28)
        static let headline = Font.custom("Poppins-SemiBold", size: 20)
        static let body = Font.custom("Poppins-Regular", size: 16)
        static let caption = Font.custom("Poppins-Regular", size: 12)
        static let button = Font.custom("Poppins-SemiBold", size: 16)
        
        static func regular(size: CGFloat) -> Font {
            Font.custom("Poppins-Regular", size: size)
        }
        
        static func medium(size: CGFloat) -> Font {
            Font.custom("Poppins-Medium", size: size)
        }
        
        static func semiBold(size: CGFloat) -> Font {
            Font.custom("Poppins-SemiBold", size: size)
        }
        
        static func bold(size: CGFloat) -> Font {
            Font.custom("Poppins-Bold", size: size)
        }
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 30
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
