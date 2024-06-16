//
//  ChipsViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation
import SwiftUI

class ChipsFieldViewModel: ObservableObject {
    @Binding var chips: [ChipsOnField]
    @Published var zoom: CGFloat = 0.6
    @Published var selectedCoordinates: [Coordinate] = []
    @Binding var disabled: Bool
    @Published var showMoveView = false
    var buttonColor: Color {
        disabled ? .gray : .black
    }
    
    let letters = Array("ABCDEFGHIJKLMNO")
    
    init(chips: Binding<[ChipsOnField]>, disabled: Binding<Bool>) {
        self._chips = chips
        self._disabled = disabled
    }
    
    func selectChip(at coordinate: Coordinate) {
        if let index = selectedCoordinates.firstIndex(of: coordinate) {
            selectedCoordinates.remove(at: index)  // Используем remove(at:) для удаления элемента по индексу
        } else {
            selectedCoordinates.append(coordinate)
        }
    }
}
