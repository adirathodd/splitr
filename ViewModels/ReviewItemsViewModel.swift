//
//  ReviewItemsViewModel.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//


import Foundation
import UIKit

@MainActor
final class ReviewItemsViewModel: ObservableObject {
    // Parsed items to display
    @Published var items: [LineItem] = []
    // Tax and tip amounts
    @Published var taxAmount: Double = 0.0
    @Published var tipAmount: Double = 0.0
    // Loading indicator
    @Published var isLoading: Bool = false
    // Error message
    @Published var errorMessage: String?

    private let parserService = ReceiptParserService()

    /// Parses receipt images (items, tax, tip) via Gemini-based parser.
    /// - Parameter images: Scanned receipt pages as UIImage array.
    func load(images: [UIImage]) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                // Parse items, tax, and tip in one call
                let (parsedItems, tax, tip) = try await parserService.parse(images: images)
                self.items = parsedItems
                self.taxAmount = tax
                self.tipAmount = tip
            } catch {
                self.errorMessage = "Failed to parse receipt: \(error.localizedDescription)"
            }

            self.isLoading = false
        }
    }
}
