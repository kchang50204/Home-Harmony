import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    Text("HomeHarmony")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)

                    Text("A simple roomate app for managing chores, groceries, bills, and shared reminders.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    VStack(spacing: 16) {
                        NavigationLink(destination: ChoresView())) {
                            HomeButton(title: "Chores", color: .green)
                        }
                        NavigationLink(destination: GroceryView()) {
                            HomeButton(title: "Grocery List", color: .orange)
                        }
                        NavigationLink(destination: RemindersView()) {
                            HomeButton(title: "House Reminders", color: .blue)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct HomeButton: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .front(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}