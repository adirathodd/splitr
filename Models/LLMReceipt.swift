//
//  LLMReceipt.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//

import Foundation

public struct LLMReceipt: Codable {
    let items: [LLMLineItem]
    let taxAmount: Double
    let tipAmount: Double
}
