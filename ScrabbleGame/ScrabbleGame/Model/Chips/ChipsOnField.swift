//
//  ChipsOnField.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

// Фишки на поле
struct ChipsOnField: Identifiable, Codable, Equatable {
    static func == (lhs: ChipsOnField, rhs: ChipsOnField) -> Bool {
        lhs.coordinate.x == rhs.coordinate.x && lhs.coordinate.y == rhs.coordinate.y
    }
    
    let id: UUID?
    var coordinate: Coordinate
    var chip: Chip?
}


