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
        VStack {
            Text("Letter in tiles:")
                .font(.footnote)
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray)
                Text("\(count)")
                    .foregroundStyle(Color.white)
            }
            .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    LetterInTileCounterView(count: Binding<Int>.constant(3))
}
