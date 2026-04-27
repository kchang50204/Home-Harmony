import SwiftUI

struct GroceryView: View {
    @StateObject var viewModel = GroceryViewModel()
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var newCategory = "General"

    let categories = ["General", "Produce", "Dairy", "Meat", "Bakery", "Frozen", "Drinks", "Snacks"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    let items = viewModel.groceryItems.filter { $0.category == category }
                    if !items.isEmpty {
                        Section(header: Text(category)) {
                            ForEach(items) { item in
                                HStack {
                                    Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isPurchased ? .green : .gray)
                                        .onTapGesture {
                                            viewModel.togglePurchased(item: item)
                                        }
                                    Text(item.name)
                                        .strikethrough(item.isPurchased)
                                        .foregroundColor(item.isPurchased ? .gray : .primary)
                                    Spacer()
                                }
                            }
                            .onDelete { offsets in
                                viewModel.deleteItem(at: offsets, in: category)
                            }
                        }
                    }
                }
                if viewModel.groceryItems.isEmpty {
                    Text("No items yet — tap + to add one")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                NavigationStack {
                    Form {
                        Section("Item Details") {
                            TextField("Item name", text: $newItemName)
                            Picker("Category", selection: $newCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                        }
                    }
                    .navigationTitle("Add Item")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                viewModel.addItem(name: newItemName, category: newCategory)
                                newItemName = ""
                                newCategory = "General"
                                showingAddItem = false
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAddItem = false }
                        }
                    }
                }
            }
        }
    }
}
