import Foundation
import Combine

class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = []
}
