//
//  ChipConstants.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

enum TileBonus {
    case doubleLetterScore
    case tripleLetterScore
    case doubleWordScore
    case tripleWordScore
    case star // Центральная клетка с дополнительным бонусом
    case none // Клетка без бонусов
}

struct TileConstants {
    static let scrabbleBoard: [String: TileBonus] = [
        "A1": .tripleWordScore,
        "D1": .doubleLetterScore,
        "H1": .tripleWordScore,
        "L1": .doubleLetterScore,
        "O1": .tripleWordScore,
        "B2": .doubleWordScore,
        "F2": .tripleLetterScore,
        "J2": .tripleLetterScore,
        "N2": .doubleWordScore,
        "C3": .doubleWordScore,
        "G3": .doubleLetterScore,
        "I3": .doubleLetterScore,
        "M3": .doubleWordScore,
        "A4": .doubleLetterScore,
        "D4": .doubleWordScore,
        "H4": .doubleLetterScore,
        "L4": .doubleWordScore,
        "O4": .doubleLetterScore,
        "E5": .doubleWordScore,
        "K5": .doubleWordScore,
        "B6": .tripleLetterScore,
        "F6": .tripleLetterScore,
        "J6": .tripleLetterScore,
        "N6": .tripleLetterScore,
        "C7": .doubleLetterScore,
        "G7": .doubleLetterScore,
        "I7": .doubleLetterScore,
        "M7": .doubleLetterScore,
        "A8": .tripleWordScore,
        "D8": .doubleLetterScore,
        "H8": .star,
        "L8": .doubleLetterScore,
        "O8": .tripleWordScore,
        "C9": .doubleLetterScore,
        "G9": .doubleLetterScore,
        "I9": .doubleLetterScore,
        "M9": .doubleLetterScore,
        "B10": .tripleLetterScore,
        "F10": .tripleLetterScore,
        "J10": .tripleLetterScore,
        "N10": .tripleLetterScore,
        "E11": .doubleWordScore,
        "K11": .doubleWordScore,
        "A12": .doubleLetterScore,
        "D12": .doubleWordScore,
        "H12": .doubleLetterScore,
        "L12": .doubleWordScore,
        "O12": .doubleLetterScore,
        "C13": .doubleWordScore,
        "G13": .doubleLetterScore,
        "I13": .doubleLetterScore,
        "M13": .doubleWordScore,
        "B14": .doubleWordScore,
        "F14": .tripleLetterScore,
        "J14": .tripleLetterScore,
        "N14": .doubleWordScore,
        "A15": .tripleWordScore,
        "D15": .doubleLetterScore,
        "H15": .tripleWordScore,
        "L15": .doubleLetterScore,
        "O15": .tripleWordScore
    ]
}
