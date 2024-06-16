//
//  MoveDTO.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation
// Ход
public struct MoveDTO: Codable {
    var gameId: UUID
    var gamerId: UUID
    var startCoordinate: Coordinate
    var stopCoordinate: Coordinate
    var chips: [ChipsOnFieldDTO]
}
