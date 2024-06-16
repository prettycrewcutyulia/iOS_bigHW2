//
//  ChipsOnHand.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

struct ChipsOnHand: View {
    @Binding var chipsOnHand: [Chip]

    var body: some View {
        List {
            ForEach(0..<chipsOnHand.count, id: \.self) { index in
                HStack {
                    Text("Alpha: \(chipsOnHand[index].alpha)")
                    Spacer()
                    Text("Point: \(chipsOnHand[index].point)")
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding()
    }
}
