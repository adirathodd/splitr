//
//  HomeTabView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/26/25.
//


import SwiftUI

struct HomeTabView: View {
    @StateObject private var vm = ReceiptHistoryViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea()

                if vm.receipts.isEmpty {
                    Text("No receipts yet")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List(vm.receipts) { receipt in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(receipt.merchant)
                                    .foregroundColor(.white)
                                Text(receipt.date, format: .dateTime.year().month().day())
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(receipt.totalPrice, format: .currency(code: "USD"))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color("CardDark"))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Your Receipts")
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 15")
    }
}