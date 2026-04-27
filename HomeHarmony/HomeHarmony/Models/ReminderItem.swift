import Foundation

struct ReminderItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var note: String = ""
    var isDone: Bool = false
}
