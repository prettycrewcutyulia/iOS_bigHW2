//
//  MoveView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import SwiftUI

struct MoveView: View {
    var selectedCoordinate: [ChipsOnField]
    @State private var inputWord = ""
    @State private var inputChip = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 40)
            VStack {
                if (selectedCoordinate.count != 0) {
                    Text("Current word: \(inputWord)")
                        .font(.title)
                    Text("from \(selectedCoordinate.first!.coordinate.description) to \(selectedCoordinate.last!.coordinate.description)")
                        .font(.subheadline)
                    
                    Text("Enter next chip")
                        .font(.subheadline)
                    
                    CustomTextView(variable: $inputChip, placeholderName: "A,0")
                        .onChange(of: inputChip) { newValue in
                            // Обрезаем текст, если его длина превышает количество координат
                            if newValue.count > 3 {
                                inputWord = String(inputWord.prefix(3))
                            }
                        }
                        .onSubmit {
                            // Проверяем, соответствует ли формат "буква,запятая,число"
                            let pattern = "^[A-Za-z],[0-9]+$"
                            if let _ = inputChip.range(of: pattern, options: .regularExpression) {
                                inputWord.append(inputChip)
                                if inputWord.count == selectedCoordinate.count {
                                    print("отправить запрос")
                                }
                            } else {
                                inputChip = ""
                                return
                            }
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
