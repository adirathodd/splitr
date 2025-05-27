//
//  ReceiptParserService.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//


import Foundation
import UIKit

final class ReceiptParserService {
    private let visionService = GeminiVisionParserService()

    /// Parses receipt images directly via Gemini, returning items, tax, and tip.
    /// - Parameter images: Scanned receipt pages.
    /// - Returns: Tuple containing array of structured LineItem, tax amount, and tip amount.
    func parse(images: [UIImage]) async throws -> (items: [LineItem], tax: Double, tip: Double) {
        let llmReceipt = try await visionService.parse(images: images)
        let items = llmReceipt.items.map {
            LineItem(name: $0.name, unitPrice: $0.unitPrice, quantity: $0.quantity)
        }
        return (items, llmReceipt.taxAmount, llmReceipt.tipAmount)
    }
}
