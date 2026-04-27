import SwiftUI

struct DashboardView: View {
    @StateObject var choreVM = ChoreViewModel()
    @StateObject var groceryVM = GroceryViewModel()
    @StateObject var billVM = BillViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Welcome Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Home 🏠")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Here's what's going on today")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8)
                    
                    // Summary Cards Row
                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "Chores",
                            value: "\(choreVM.chores.filter { !$0.isCompleted }.count)",
                            subtitle: "pending",
                            color: .green,
                            icon: "checkmark.circle.fill"
                        )
                        SummaryCard(
                            title: "Grocery",
                            value: "\(groceryVM.groceryItems.filter { !$0.isPurchased }.count)",
                            subtitle: "items left",
                            color: .orange,
                            icon: "cart.fill"
                        )
                        SummaryCard(
                            title: "Bills",
                            value: "\(billVM.bills.count)",
                            subtitle: "total",
                            color: .purple,
                            icon: "dollarsign.circle.fill"
                        )
                    }
                    
                    // Pending Chores Section
                    if !choreVM.chores.filter({ !$0.isCompleted }).isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pending Chores")
                                .font(.headline)
                                .padding(.horizontal)
                            ForEach(choreVM.chores.filter { !$0.isCompleted }) { chore in
                                HStack {
                                    Image(systemName: "circle")
                                        .foregroundColor(.green)
                                    VStack(alignment: .leading) {
                                        Text(chore.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text("Assigned to: \(chore.assignedTo)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(chore.dueDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.03), radius: 4)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Upcoming Bills Section
                    if !billVM.bills.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Upcoming Bills")
                                .font(.headline)
                                .padding(.horizontal)
                            ForEach(billVM.bills) { bill in
                                HStack {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .foregroundColor(.purple)
                                    VStack(alignment: .leading) {
                                        Text(bill.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                        Text("Due: \(bill.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("$\(String(format: "%.2f", bill.amount))")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.03), radius: 4)
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Grocery Summary
                    if !groceryVM.groceryItems.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Grocery List")
                                .font(.headline)
                                .padding(.horizontal)
                            HStack {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.orange)
                                Text("\(groceryVM.groceryItems.filter { !$0.isPurchased }.count) items remaining out of \(groceryVM.groceryItems.count)")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.03), radius: 4)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
}
