import Foundation

struct Roommate: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var email: String = ""
}
