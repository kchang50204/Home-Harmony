import SwiftUI

@main
struct HomeHarmonyApp: App {
    @StateObject var choreVM = ChoreViewModel()
    @StateObject var groceryVM = GroceryViewModel()
    @StateObject var billVM = BillViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(choreVM)
                .environmentObject(groceryVM)
                .environmentObject(billVM)
        }
    }
}
