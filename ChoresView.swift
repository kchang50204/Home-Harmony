import SwiftUI

struct ChoresView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Chores Screen")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("This screen will let roommates add chores and mark them as complete.")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Chores")
    }
}

#Preview {
    ChoresView()
}