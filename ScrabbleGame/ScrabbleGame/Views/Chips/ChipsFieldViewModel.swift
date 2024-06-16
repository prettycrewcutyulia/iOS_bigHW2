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
    @Published var selectedCoordinates =  Set<Coordinate>()
    @Binding var disabled: Bool
    
    let letters = Array("ABCDEFGHIJKLMNO")
    
    init(chips: Binding<[ChipsOnField]>, disabled: Binding<Bool>) {
        self._chips = chips
        self._disabled = disabled
    }
    
    func selectChip(at coordinate: Coordinate) {
        if(selectedCoordinates.contains(coordinate)) {
            selectedCoordinates.remove(coordinate)
        } else {
            selectedCoordinates.insert(coordinate)
        }
    }
}
