//
//  ChipsOnField.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

// Фишки на поле
struct ChipsOnField: Identifiable, Codable {
    let id: UUID?
    var coordinate: Coordinate
    var chip: Chip?
}


