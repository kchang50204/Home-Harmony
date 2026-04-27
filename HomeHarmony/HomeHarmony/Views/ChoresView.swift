import SwiftUI

struct ChoresView: View {
    @EnvironmentObject var viewModel: ChoreViewModel
    @State private var showingAddChore = false
    @State private var showCompleted = true
    @State private var newTitle = ""
    @State private var newAssignedTo = ""
    @State private var newDueDate = Date()

    var filteredChores: [Chore] {
        showCompleted ? viewModel.chores : viewModel.chores.filter { !$0.isCompleted }
    }

    var completedCount: Int {
        viewModel.chores.filter { $0.isCompleted }.count
    }

    var totalCount: Int {
        viewModel.chores.count
    }

    var progress: Double {
        totalCount == 0 ? 0 : Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        NavigationStack {
            List {
                // Progress Bar Section
                if totalCount > 0 {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Progress")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(completedCount) of \(totalCount) done")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 12)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(progress == 1.0 ? Color.green : Color.orange)
                                        .frame(width: geometry.size.width * progress, height: 12)
                                        .animation(.easeInOut(duration: 0.3), value: progress)
                                }
                            }
                            .frame(height: 12)
                            if progress == 1.0 {
                                Text("All chores done! 🎉")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Chores List Section
                Section {
                    if filteredChores.isEmpty {
                        Text(showCompleted ? "No chores yet — tap + to add one" : "No pending chores 🎉")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredChores) { chore in
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
                                HStack {
                                    Text("Due: \(chore.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(Calendar.current.startOfDay(for: chore.dueDate) < Calendar.current.startOfDay(for: Date()) && !chore.isCompleted ? .red : .gray)
                                    if Calendar.current.startOfDay(for: chore.dueDate) < Calendar.current.startOfDay(for: Date()) && !chore.isCompleted {
                                        Text("Overdue")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: viewModel.deleteChore)
                    }
                }
            }
            .navigationTitle("Chores")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(showCompleted ? "Hide Completed" : "Show Completed") {
                        showCompleted.toggle()
                    }
                    .foregroundColor(.green)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        EditButton()
                        Button(action: { showingAddChore = true }) {
                            Image(systemName: "plus")
                        }
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
}
