//
//  ChipField.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

import SwiftUI

struct ChipField: View {
    @Binding var chips: [ChipsOnField]
    @GestureState private var zoom = 0.6
    
    let letters = Array("ABCDEFGHIJKLMNO")
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 10
            let gridSize = size * 10
            
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer().frame(width: size, height: size)
                        ForEach(0..<15, id: \.self) { col in
                            Text(String(letters[col]))
                                .frame(width: size, height: size)
                                .border(Color.black, width: 0.3)
                        }
                    }
                    ForEach(0..<15, id: \.self) { row in
                        HStack(spacing: 0) {
                            Text(String(row + 1)) // Отображаем координаты y начиная с 1
                                .frame(width: size, height: size)
                                .border(Color.black, width: 0.3)
                            ForEach(0..<15, id: \.self) { col in
                                let coordinate = Coordinate(x: String(letters[col]), y: row + 1) // Обновляем координаты y
                        
                                let chip = chips.first { $0.coordinate == coordinate }
                                Cell(chip: chip, size: size, coordinate: coordinate)
                                    .onTapGesture {
                                        print("Выбрали")
                                        selectChip(at: coordinate)
                                    }
                            }
                        }
                    }
                }
                Spacer()
            }
            .frame(width: gridSize, height: gridSize)
            .scaleEffect(zoom)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    private func selectChip(at coordinate: Coordinate) {
        if let index = chips.firstIndex(where: { $0.coordinate == coordinate }) {
            chips[index].isSelected.toggle()
        }
    }
}

struct Cell: View {
    var chip: ChipsOnField?
    var size: CGFloat
    var coordinate: Coordinate
    
    var body: some View {
        let selected = chip?.isSelected ?? false
        let borderColor = selected ? Color.yellow : Color.black
        let bonus = TileConstants.scrabbleBoard["\(coordinate.x)\(coordinate.y)"] ?? .none
        
        ZStack {
            Rectangle()
                .fill(backgroundColor(for: bonus))
                .frame(width: size, height: size)
                .border(borderColor, width: 0.3)
            if let chip = chip {
                Text(chip.chip.alpha)
            } else {
                Text(text(for: bonus))
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func text(for bonus: TileBonus) -> String {
        switch bonus {
        case .doubleLetterScore:
            return "2xLS"
        case .tripleLetterScore:
            return "3xLS"
        case .doubleWordScore:
            return "2xWS"
        case .tripleWordScore:
            return "3xWS"
        case .star:
            return "⭐️"
        case .none:
            return ""
        }
    }
    
    private func backgroundColor(for bonus: TileBonus) -> Color {
        switch bonus {
        case .doubleLetterScore:
            return Color.blue
        case .tripleLetterScore:
            return Color.green
        case .doubleWordScore:
            return Color.cyan
        case .tripleWordScore:
            return Color.red
        case .star:
            return Color.cyan
        case .none:
            return Color.white
        }
    }
}

struct ChipField_Previews: PreviewProvider {
    static var previews: some View {
        ChipField(chips: .constant([
            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "H", y: 8), chip: Chip(alpha: "A", point: 1), isSelected: false),
            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "I", y: 8), chip: Chip(alpha: "B", point: 3), isSelected: false)
        ]))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
