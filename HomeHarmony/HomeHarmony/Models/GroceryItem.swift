import Foundation

struct GroceryItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var category: String = "General"
    var isPurchased: Bool = false
}
