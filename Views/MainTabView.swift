//
//  MainTabView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//

import SwiftUI
import UIKit

enum SplitrTab: Hashable {
    case home, camera, profile
}

struct MainTabView: View {
    @State private var selection: SplitrTab = .home
    @State private var lastSelection: SplitrTab = .home
    @State private var isScanning = false
    @State private var reviewImages: [UIImage] = []
    @State private var showReview = false

    var body: some View {
        // Custom binding to intercept Camera tab taps
        let selectionBinding = Binding<SplitrTab>(
            get: { self.selection },
            set: { newTab in
                if newTab == .camera {
                    // Remember current tab, then open scanner
                    lastSelection = selection
                    isScanning = true
                }
                selection = newTab
            }
        )

        TabView(selection: selectionBinding) {
            HomeTabView()
                .tag(SplitrTab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // Placeholder view for the Camera tab
            Color.clear
                .tag(SplitrTab.camera)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }

            ProfileView()
                .tag(SplitrTab.profile)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        // Scanner sheet
        .sheet(isPresented: $isScanning, onDismiss: {
            // If cancelled, go back to previous tab
            if selection == .camera {
                selection = lastSelection
            }
        }) {
            ScanReceiptView { images in
                reviewImages = images
                showReview = true
                isScanning = false
            }
            .interactiveDismissDisabled(false)
        }
        // Review items sheet
        .sheet(isPresented: $showReview) {
            ReviewItemsView(images: reviewImages)
        }
        .accentColor(Color("AccentColor"))
        .preferredColorScheme(.dark)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
