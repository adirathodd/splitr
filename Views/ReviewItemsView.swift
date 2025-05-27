//
//  ReviewItemsView.swift
//  splitr
//
//  Created by Adityasinh Rathod on 5/27/25.
//

import SwiftUI
import UIKit

struct ReviewItemsView: View {
    @Environment(\.dismiss) private var dismiss

    /// Scanned receipt images to parse.
    let images: [UIImage]
    @StateObject private var vm = ReviewItemsViewModel()
    
    init(images: [UIImage]) {
        self.images = images
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea()

                if vm.isLoading {
                    ProgressView("Parsing receipt...")
                        .tint(.white)
                } else {
                    List {
                        Section("Items") {
                            ForEach($vm.items) { $item in
                                VStack(alignment: .leading, spacing: 8) {
                                    // Editable name
                                    TextField("Item name", text: $item.name)
                                        .foregroundColor(.white)
                                    // Editable quantity
                                    HStack {
                                        Text("Qty:")
                                            .foregroundColor(.gray)
                                        Stepper(value: $item.quantity, in: 1...100) {
                                            Text("\(item.quantity)")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    // Editable price
                                    HStack {
                                        Text("Price:")
                                            .foregroundColor(.gray)
                                        TextField(
                                            "0.00",
                                            value: $item.unitPrice,
                                            format: .currency(code: "USD")
                                        )
                                        .keyboardType(.decimalPad)
                                        .foregroundColor(.white)
                                    }
                                }
                                .listRowBackground(Color("CardDark"))
                            }
                        }

                        Section("Fees") {
                            HStack {
                                Text("Tax:")
                                    .foregroundColor(.gray)
                                TextField(
                                    "0.00",
                                    value: $vm.taxAmount,
                                    format: .currency(code: "USD")
                                )
                                .keyboardType(.decimalPad)
                                .foregroundColor(.white)
                            }
                            .listRowBackground(Color("CardDark"))

                            HStack {
                                Text("Tip:")
                                    .foregroundColor(.gray)
                                TextField(
                                    "0.00",
                                    value: $vm.tipAmount,
                                    format: .currency(code: "USD")
                                )
                                .keyboardType(.decimalPad)
                                .foregroundColor(.white)
                            }
                            .listRowBackground(Color("CardDark"))
                        }

                        Section {
                            Button("Continue") {
                                // TODO: implement continue action
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color("AccentColor"))
                            .listRowBackground(Color("BackgroundDark"))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color("BackgroundDark"))
                }
            }
        }
        .task {
            vm.load(images: images)
        }
        .navigationTitle("Review Items")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }
}

struct ReviewItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewItemsView(images: [UIImage(named: "sampleReceipt")!])
            .preferredColorScheme(.dark)
    }
}
