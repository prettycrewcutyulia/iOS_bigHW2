//
//  ChipsOnHand.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

struct ChipsOnHand: View {
    @ObservedObject var viewModel = ChipOnHandViewModel()

    var body: some View {
        List {
            Text("Chips on you hand:")
                .font(.title)
            ForEach(0..<viewModel.chipsOnHand.count, id: \.self) { index in
                HStack {
                    Text("Alpha: \(viewModel.chipsOnHand[index].alpha)")
                    Spacer()
                    Text("Point: \(viewModel.chipsOnHand[index].point)")
                }
            }
        }
        .listStyle(.plain)
        .padding()
        .onAppear {
            viewModel.onAppear()
        }
    }
}
