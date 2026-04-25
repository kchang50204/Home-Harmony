import Foundation

struct Chore: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var assignedTo: String
    var isCompleted: Bool = false
    var dueDate: Date = Date()
}
