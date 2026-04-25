import Foundation

struct Bill: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var amount: Double
    var dueDate: Date = Date()
    var paidBy: [String] = []
}
