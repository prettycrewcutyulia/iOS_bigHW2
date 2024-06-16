//
//  MoveView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import SwiftUI

struct MoveView: View {
    var index = 0
    @State var selectedCoordinate: [ChipsOnField]
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
                            if let flag = inputChip.range(of: pattern, options: .regularExpression) {
                                inputWord.append(inputChip)

                                let result =  extractLetterAndNumber(from: inputChip)
                                selectedCoordinate[index].chip = Chip(alpha: result.letter, point: result.number)
                                if inputWord.count == selectedCoordinate.count {
                                    Task {
                                        do {
                                            let isValid = try await NetworkService.shared.checkWord(word: inputWord)
                                            if isValid {
                                                let move = MoveDTO(
                                                    gameId: UUID(uuidString: UserDefaultsService.shared.getCurrentGameId() ?? "") ?? UUID(),
                                                    gamerId: UserDefaultsService.shared.getCurrentUserSafe()?.id ?? UUID(),
                                                    startCoordinate: selectedCoordinate.first!.coordinate,
                                                    stopCoordinate: selectedCoordinate.last!.coordinate,
                                                    chips: selectedCoordinate.map { ChipsOnFieldDTO($0) })
                                                try await NetworkService.shared.createMove(move: move)
                                            }
                                        }
                                    }
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
    
    func extractLetterAndNumber(from input: String) -> (letter: String, number: Int) {
        // Разделяем входную строку по запятой
        let components = input.split(separator: ",")
        
        // Первый компонент - это буква, второй - число
        let letter = String(components[0])
        let number = Int(components[1])!
        
        // Возвращаем результат в виде кортежа
        return (letter, number)
    }
}
