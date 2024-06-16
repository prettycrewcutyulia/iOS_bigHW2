//
//  MoveView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import SwiftUI

struct MoveView: View {
    var selectedCoordinate: [Coordinate]
    @State private var inputWord = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                                .edgesIgnoringSafeArea(.all)
                                .blur(radius: 40)
            VStack {
                if (selectedCoordinate.count != 0) {
                    Text("Enter word:")
                        .font(.title)
                    Text("from \(selectedCoordinate.first!) to \(selectedCoordinate.last!)")
                        .font(.subheadline)
                    
                    CustomTextView(variable: $inputWord, placeholderName: "Enter word")
                        .onChange(of: inputWord) { newValue in
                            // Обрезаем текст, если его длина превышает количество координат
                            if newValue.count > selectedCoordinate.count {
                                inputWord = String(inputWord.prefix(selectedCoordinate.count))
                            }
                        }
                        .onSubmit {
                            // отправить запрос
                            print("отправить запрос")
                        }
                        .padding()
                } else {
                    Text("First, select the coordinates where you want to place the chips)")
                        .padding()
                }
            }
        }
    }
}
