//
//  CellView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import SwiftUI

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
