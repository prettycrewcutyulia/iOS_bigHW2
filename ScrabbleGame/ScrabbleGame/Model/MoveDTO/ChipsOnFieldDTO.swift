//
//  ChipsOnFieldDTO.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation

// Фишка на поле
public struct ChipsOnFieldDTO: Codable {
    var coordinate: Coordinate
    var chip: Chip
    
    init(_ from: ChipsOnField) {
        self.coordinate = from.coordinate
        self.chip = from.chip ?? Chip(alpha: "", point: 0)
    }
}
