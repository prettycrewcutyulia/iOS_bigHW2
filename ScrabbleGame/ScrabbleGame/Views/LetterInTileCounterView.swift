//
//  LetterInTileCounterView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

struct LetterInTileCounterView: View {
    @Binding var count: Int
    var body: some View {
        HStack {
            Text("Letter in tiles:")
                .fontWeight(.bold)
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray)
                Text("\(count)")
                    .foregroundStyle(Color.white)
            }
            .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    LetterInTileCounterView(count: Binding<Int>.constant(3))
}
