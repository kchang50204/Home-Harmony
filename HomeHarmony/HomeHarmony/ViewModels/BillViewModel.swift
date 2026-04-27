import Foundation
import Combine
import SwiftUI

class BillViewModel: ObservableObject {
    @Published var bills: [Bill] = [] {
        didSet { save() }
    }
    
    init() { load() }
    
    func addBill(name: String, amount: Double, dueDate: Date) {
        let newBill = Bill(name: name, amount: amount, dueDate: dueDate)
        bills.append(newBill)
    }
    
    func togglePaid(bill: Bill, roommate: String) {
        if let index = bills.firstIndex(where: { $0.id == bill.id }) {
            if bills[index].paidBy.contains(roommate) {
                bills[index].paidBy.removeAll { $0 == roommate }
            } else {
                bills[index].paidBy.append(roommate)
            }
        }
    }
    
    func deleteBill(at offsets: IndexSet) {
        bills.remove(atOffsets: offsets)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(bills) {
            UserDefaults.standard.set(encoded, forKey: "saved_bills")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "saved_bills"),
           let decoded = try? JSONDecoder().decode([Bill].self, from: data) {
            bills = decoded
        }
    }
}
