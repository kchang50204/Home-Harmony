import SwiftUI

struct ChoresView: View {
    @StateObject var viewModel = ChoreViewModel()
    @State private var showingAddChore = false
    @State private var newTitle = ""
    @State private var newAssignedTo = ""
    @State private var newDueDate = Date()

    var body: some View {
        List {
            ForEach(viewModel.chores) { chore in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: chore.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(chore.isCompleted ? .green : .gray)
                            .onTapGesture {
                                viewModel.toggleChore(chore: chore)
                            }
                        Text(chore.title)
                            .font(.headline)
                            .strikethrough(chore.isCompleted)
                        Spacer()
                    }
                    Text("Assigned to: \(chore.assignedTo)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Due: \(chore.dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: viewModel.deleteChore)
        }
        .navigationTitle("Chores")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddChore = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddChore) {
            NavigationStack {
                Form {
                    Section("Chore Details") {
                        TextField("Chore name", text: $newTitle)
                        TextField("Assigned to", text: $newAssignedTo)
                        DatePicker("Due date", selection: $newDueDate, displayedComponents: .date)
                    }
                }
                .navigationTitle("Add Chore")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            viewModel.addChore(title: newTitle, assignedTo: newAssignedTo, dueDate: newDueDate)
                            newTitle = ""
                            newAssignedTo = ""
                            newDueDate = Date()
                            showingAddChore = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showingAddChore = false }
                    }
                }
            }
        }
    }
}
