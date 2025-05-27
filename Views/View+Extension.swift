//
//  View+Extension.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//

import SwiftUI

extension View {
    /// Dismisses the keyboard when called on any View.
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
