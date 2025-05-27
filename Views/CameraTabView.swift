//
//  CameraTabView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//

import SwiftUI

struct CameraTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.gray.opacity(0.7))
                    
                    Text("Tap the Camera tab to scan a receipt")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Camera")
        }
    }
}

struct CameraTabView_Previews: PreviewProvider {
    static var previews: some View {
        CameraTabView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 15")
    }
}
