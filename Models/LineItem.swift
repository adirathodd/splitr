//
//  LineItem.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//

import Foundation

struct LineItem: Identifiable {
    let id = UUID()
    var name: String
    var unitPrice: Double
    var quantity: Int
}
