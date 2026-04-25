import Foundation
import Combine

class ChoreViewModel: ObservableObject {
    @Published var chores: [Chore] = []
}
