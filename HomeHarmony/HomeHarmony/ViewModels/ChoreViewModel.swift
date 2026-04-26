import Foundation
import Combine
import SwiftUI

class ChoreViewModel: ObservableObject {
    @Published var chores: [Chore] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func addChore(title: String, assignedTo: String, dueDate: Date) {
        let newChore = Chore(title: title, assignedTo: assignedTo, dueDate: dueDate)
        chores.append(newChore)
    }
    
    func toggleChore(chore: Chore) {
        if let index = chores.firstIndex(where: { $0.id == chore.id }) {
            chores[index].isCompleted.toggle()
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        chores.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    private func save() {
        if let encoded = try? JSONEncoder().encode(chores) {
            UserDefaults.standard.set(encoded, forKey: "saved_chores")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "saved_chores"),
           let decoded = try? JSONDecoder().decode([Chore].self, from: data) {
            chores = decoded
        }
    }
}
