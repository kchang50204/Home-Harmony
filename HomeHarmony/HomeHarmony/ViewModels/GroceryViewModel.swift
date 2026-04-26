import Foundation
import Combine
import SwiftUI

class GroceryViewModel: ObservableObject {
    @Published var groceryItems: [GroceryItem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func addItem(name: String, category: String) {
        let newItem = GroceryItem(name: name, category: category)
        groceryItems.append(newItem)
    }
    
    func togglePurchased(item: GroceryItem) {
        if let index = groceryItems.firstIndex(where: { $0.id == item.id }) {
            groceryItems[index].isPurchased.toggle()
        }
    }
    
    func deleteItem(at offsets: IndexSet, in category: String) {
        let categoryItems = groceryItems.indices.filter {
            groceryItems[$0].category == category
        }
        let indicesToDelete = offsets.map { categoryItems[$0] }
        groceryItems.remove(atOffsets: IndexSet(indicesToDelete))
    }
    
    // MARK: - Persistence
    private func save() {
        if let encoded = try? JSONEncoder().encode(groceryItems) {
            UserDefaults.standard.set(encoded, forKey: "saved_grocery")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "saved_grocery"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceryItems = decoded
        }
    }
}
