//
//  GeminiVisionParserService.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//

//
//  GeminiVisionParserService.swift
//  splitr
//
//  Sends receipt images directly to Google Gemini multimodal API and parses JSON.
//  Created by Your Name on YYYY/MM/DD.
//

import Foundation
import UIKit
import FirebaseAI

/// Uses Gemini multimodal to extract items, tax, and tip from receipt images.
final class GeminiVisionParserService {
    /// Sends images and returns structured receipt data.
    func parse(images: [UIImage]) async throws -> LLMReceipt {
        // Initialize Google AI via FirebaseAI SDK
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())
        let model = ai.generativeModel(modelName: "gemini-2.0-flash")

        // Use the first scanned page for parsing
        guard let image = images.first else {
            throw NSError(domain: "GeminiVisionParserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No images provided"])
        }

        // Prompt to instruct Gemini to extract structured receipt data
        let prompt = """
        You are a receipt-parsing assistant. Given this receipt image, extract:
        - items: array of { name, unitPrice, quantity }
        - taxAmount: total tax paid
        - tipAmount: gratuity paid
        Only output valid JSON matching:
        {
          "items": [{ "name": "...", "unitPrice": 0.00, "quantity": 1 }],
          "taxAmount": 0.00,
          "tipAmount": 0.00
        }
        """

        do {
            let response = try await model.generateContent(image, prompt)

            // Clean any markdown fences
            let jsonString = response.text?
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            guard let jsonData = jsonString.data(using: .utf8) else {
                throw NSError(domain: "GeminiVisionParserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON data"])
            }

            let llmReceipt = try JSONDecoder().decode(LLMReceipt.self, from: jsonData)

            return llmReceipt
        } catch {
            print("❌ [Error] GeminiVisionParserService.parse failed with error:", error)
            throw error
        }
    }
}
