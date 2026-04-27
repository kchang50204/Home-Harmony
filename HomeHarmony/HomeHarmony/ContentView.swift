import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            ChoresView()
                .tabItem { Label("Chores", systemImage: "checkmark.circle.fill") }
            GroceryView()
                .tabItem { Label("Grocery", systemImage: "cart.fill") }
            BillsView()
                .tabItem { Label("Bills", systemImage: "dollarsign.circle.fill") }
            RemindersView()
                .tabItem { Label("Reminders", systemImage: "bell.fill") }
        }
    }
}

#Preview {
    ContentView()
}
