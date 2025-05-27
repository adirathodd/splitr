//
//  ReceiptHistoryViewModel.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import Foundation

@MainActor
class ReceiptHistoryViewModel: ObservableObject {
    @Published var receipts: [Receipt] = []

    init() {
        loadReceipts()
    }

    func loadReceipts() {
        // TODO: replace with real persistence/Firestore fetch
        receipts = [
            Receipt(id: UUID(), merchant: "Grocery Store", date: Date(), totalPrice: 56.23),
            Receipt(id: UUID(), merchant: "Coffee Shop", date: Date().addingTimeInterval(-86400), totalPrice: 12.75)
        ]
    }
}