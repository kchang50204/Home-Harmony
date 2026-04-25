import Foundation
import Combine
import SwiftUI

class ChoreViewModel: ObservableObject {
    @Published var chores: [Chore] = []
    
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
}
