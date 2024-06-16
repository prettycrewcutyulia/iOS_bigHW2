//
//  ChipField.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

import SwiftUI

struct ChipField: View {
    @ObservedObject var viewModel: ChipsFieldViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 10
            let gridSize = size * 10

            VStack(alignment: .center) {
                VStack(alignment:.center, spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer().frame(width: size, height: size)
                        ForEach(0..<15, id: \.self) { col in
                            Text(String(viewModel.letters[col]))
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
                                let coordinate = Coordinate(x: String(viewModel.letters[col]), y: row + 1) // Обновляем координаты y
                                
                                let chip = viewModel.chips.first { $0.coordinate == coordinate }
                                Cell(chip: chip, size: size, coordinate: coordinate,
                                     isSelected: viewModel.selectedCoordinates.contains(coordinate))
                                .onTapGesture {
                                    print("Выбрали")
                                    viewModel.selectChip(at: coordinate)
                                }
                            }
                        }
                    }
                }
                .frame(
                    width: gridSize * viewModel.zoom,
                    height: gridSize * viewModel.zoom
                )
                .scaleEffect(viewModel.zoom)
                .gesture(MagnificationGesture() // Добавление жеста масштабирования
                    .onChanged { value in
                        viewModel.zoom = value.magnitude // Изменение масштаба в зависимости от жеста
                    }
                    .onEnded { value in
                        let delta = value.magnitude / viewModel.zoom
                        viewModel.zoom *= delta // Финальное применение масштаба
                        if viewModel.zoom < 0.6 {
                            viewModel.zoom = 0.6 // Устанавливаем минимальный масштаб, чтобы избежать слишком маленького размера
                        }
                    })
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .defaultScrollAnchor(.center)
                
                CustomButton(buttonText: Binding<String>.constant("Move"), buttonColor: Binding<Color>.constant(.black), isDisabled: viewModel.disabled) {
                    // Тут будет открываться новый экран для ввода хода)
                }
            }
        }
    }
}

//struct ChipField_Previews: PreviewProvider {
//    static var previews: some View {
//        ChipField(chips: .constant([
//            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "H", y: 8), chip: Chip(alpha: "A", point: 1)),
//            ChipsOnField(id: UUID(), coordinate: Coordinate(x: "I", y: 8), chip: Chip(alpha: "B", point: 3))
//        ]))
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
