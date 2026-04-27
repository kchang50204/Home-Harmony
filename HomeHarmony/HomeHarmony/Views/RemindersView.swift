import SwiftUI

struct RemindersView: View {
    @State private var reminders: [ReminderItem] = []
    @State private var showingAddReminder = false
    @State private var newTitle = ""
    @State private var newDate = Date()
    @State private var newNote = ""

    var body: some View {
        NavigationStack {
            List {
                if reminders.isEmpty {
                    Text("No reminders yet — tap + to add one")
                        .foregroundColor(.gray)
                } else {
                    ForEach(reminders) { reminder in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: reminder.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(reminder.isDone ? .green : .gray)
                                    .onTapGesture { toggleReminder(reminder) }
                                Text(reminder.title)
                                    .font(.headline)
                                    .strikethrough(reminder.isDone)
                                Spacer()
                            }
                            Text(reminder.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                            if !reminder.note.isEmpty {
                                Text(reminder.note)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteReminder)
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReminder = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                NavigationStack {
                    Form {
                        Section("Reminder Details") {
                            TextField("Title", text: $newTitle)
                            DatePicker("Date & Time", selection: $newDate)
                            TextField("Note (optional)", text: $newNote)
                        }
                    }
                    .navigationTitle("Add Reminder")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let reminder = ReminderItem(title: newTitle, date: newDate, note: newNote)
                                reminders.append(reminder)
                                newTitle = ""
                                newDate = Date()
                                newNote = ""
                                showingAddReminder = false
                                save()
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAddReminder = false }
                        }
                    }
                }
            }
            .onAppear { load() }
        }
    }

    func toggleReminder(_ reminder: ReminderItem) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isDone.toggle()
            save()
        }
    }

    func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "saved_reminders")
        }
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: "saved_reminders"),
           let decoded = try? JSONDecoder().decode([ReminderItem].self, from: data) {
            reminders = decoded
        }
    }
}
