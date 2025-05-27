//
//  splitrApp.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct splitrApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var authVM = AuthViewModel()

  var body: some Scene {
    WindowGroup {
        ContentView()
            .environmentObject(authVM)
            .preferredColorScheme(.dark)
    }
  }
}
