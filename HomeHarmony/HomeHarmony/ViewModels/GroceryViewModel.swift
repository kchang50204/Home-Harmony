import Foundation
import Combine
import SwiftUI

class GroceryViewModel: ObservableObject {
    @Published var groceryItems: [GroceryItem] = []
    
    func addItem(name: String, category: String) {
        let newItem = GroceryItem(name: name, category: category)
        groceryItems.append(newItem)
    }
    
    func togglePurchased(item: GroceryItem) {
        if let index = groceryItems.firstIndex(where: { $0.id == item.id }) {
            groceryItems[index].isPurchased.toggle()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        groceryItems.remove(atOffsets: offsets)
    }
}
