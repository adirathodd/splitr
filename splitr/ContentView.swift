//
//  ContentView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: AuthViewModel

    var body: some View {
        Group {
            if vm.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: vm.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
