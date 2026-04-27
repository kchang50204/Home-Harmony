import SwiftUI

struct BillsView: View {
    @EnvironmentObject var viewModel: BillViewModel
    @State private var showingAddBill = false
    @State private var newBillName = ""
    @State private var newAmount = ""
    @State private var newDueDate = Date()
    @State private var exchangeRate: Double? = nil
    @State private var selectedCurrency = "EUR"

    let currencies = ["EUR", "GBP", "JPY", "CAD", "AUD", "MXN"]
    let roommates = ["Kevin", "Frank", "Member 3"]

    var body: some View {
        NavigationStack {
            List {
                Section(header: Label("Currency Converter", systemImage: "dollarsign.arrow.circlepath")) {
                    Picker("Convert USD to", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) { Text($0) }
                    }
                    .onChange(of: selectedCurrency) { _ in
                        Task { await fetchRate() }
                    }
                    if let rate = exchangeRate {
                        Text("1 USD = \(String(format: "%.4f", rate)) \(selectedCurrency)")
                            .foregroundColor(.green)
                    } else {
                        Text("Fetching rate...")
                            .foregroundColor(.gray)
                    }
                }

                Section(header: Label("Bills", systemImage: "list.clipboard")) {
                    if viewModel.bills.isEmpty {
                        Text("No bills yet — tap + to add one")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.bills) { bill in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(bill.name)
                                        .font(.headline)
                                    Spacer()
                                    Text("$\(String(format: "%.2f", bill.amount))")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                }
                                HStack {
                                    Text("Due: \(bill.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundColor(Calendar.current.startOfDay(for: bill.dueDate) < Calendar.current.startOfDay(for: Date()) ? .red : .gray)
                                    if Calendar.current.startOfDay(for: bill.dueDate) < Calendar.current.startOfDay(for: Date()) {
                                        Text("Overdue")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                }
                                Text("Split: $\(String(format: "%.2f", bill.amount / Double(roommates.count))) per person")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                if let rate = exchangeRate {
                                    Text("\(selectedCurrency): \(String(format: "%.2f", bill.amount * rate))")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                HStack {
                                    ForEach(roommates, id: \.self) { roommate in
                                        let paid = bill.paidBy.contains(roommate)
                                        Button(action: {
                                            viewModel.togglePaid(bill: bill, roommate: roommate)
                                        }) {
                                            Text(roommate)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(paid ? Color.green : Color.gray.opacity(0.3))
                                                .foregroundColor(paid ? .white : .primary)
                                                .cornerRadius(8)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: viewModel.deleteBill)
                    }
                }
            }
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBill = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBill) {
                NavigationStack {
                    Form {
                        Section("Bill Details") {
                            TextField("Bill name", text: $newBillName)
                            TextField("Amount ($)", text: $newAmount)
                                .keyboardType(.decimalPad)
                            DatePicker("Due date", selection: $newDueDate, displayedComponents: .date)
                        }
                    }
                    .navigationTitle("Add Bill")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                if let amount = Double(newAmount) {
                                    viewModel.addBill(name: newBillName, amount: amount, dueDate: newDueDate)
                                    newBillName = ""
                                    newAmount = ""
                                    newDueDate = Date()
                                    showingAddBill = false
                                }
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAddBill = false }
                        }
                    }
                }
            }
            .task {
                await fetchRate()
            }
        }
    }

    func fetchRate() async {
        do {
            let rates = try await ExchangeRateService.fetchRates()
            await MainActor.run {
                exchangeRate = rates[selectedCurrency]
            }
        } catch {
            print("Error fetching rate: \(error)")
        }
    }
}
