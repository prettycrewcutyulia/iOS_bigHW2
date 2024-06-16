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
    @State private var zoom: CGFloat = 0.6
    @State private var selectedCoordinates =  Set<Coordinate>()
    
    let letters = Array("ABCDEFGHIJKLMNO")
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 10
            let gridSize = size * 10
            
            ScrollView([.horizontal, .vertical]) {
                VStack(alignment:.center, spacing: 0) {
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
                                Cell(chip: chip, size: size, coordinate: coordinate,
                                     isSelected: selectedCoordinates.contains(coordinate))
                                    .onTapGesture {
                                        print("Выбрали")
                                        selectChip(at: coordinate)
                                    }
                            }
                        }
                    }
                }
                .offset(x: -(gridSize/2), y: -(gridSize/2))
                .scaleEffect(zoom)
            }
            .frame(maxWidth: .infinity, maxHeight: gridSize)
            .scaleEffect(zoom)
            .gesture(MagnificationGesture() // Добавление жеста масштабирования
                           .onChanged { value in
                               zoom = value.magnitude // Изменение масштаба в зависимости от жеста
                           }
                           .onEnded { value in
                               let delta = value.magnitude / zoom
                               zoom *= delta // Финальное применение масштаба
                               if zoom < 0.6 {
                                   zoom = 0.6 // Устанавливаем минимальный масштаб, чтобы избежать слишком маленького размера
                               }
                           })
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
    
    private func selectChip(at coordinate: Coordinate) {
        if let index = chips.firstIndex(where: { $0.coordinate == coordinate }) {
            if(selectedCoordinates.contains(coordinate)) {
                selectedCoordinates.remove(coordinate)
            } else {
                selectedCoordinates.insert(coordinate)
            }
        } else {
            print("NotFound")
        }
    }
}

struct Cell: View {
    var chip: ChipsOnField?
    var size: CGFloat
    var coordinate: Coordinate
    var isSelected: Bool
    
    var body: some View {
        let borderColor = isSelected ? Color.yellow : Color.black
        let bonus = TileConstants.scrabbleBoard["\(coordinate.x)\(coordinate.y)"] ?? .none
        let borderWidth = isSelected ? 5 : 0.3
        
        ZStack {
            Rectangle()
                .fill(backgroundColor(for: bonus))
                .frame(width: size, height: size)
                .border(borderColor, width: borderWidth)
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
            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "H", y: 8), chip: Chip(alpha: "A", point: 1)),
            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "I", y: 8), chip: Chip(alpha: "B", point: 3))
        ]))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
