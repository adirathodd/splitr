//
//  Receipt.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//

import Foundation

struct Receipt: Identifiable {
    let id: UUID
    let merchant: String
    let date: Date
    let totalPrice: Double
}
