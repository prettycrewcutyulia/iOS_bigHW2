//
//  ScoreboardModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import Foundation

struct ScoreboardModel: Comparable, CustomStringConvertible {
    
    let player: String?
    let score: Int
    
    static func < (lhs: ScoreboardModel, rhs: ScoreboardModel) -> Bool {
        return lhs.score < rhs.score
    }
    
    static func == (lhs: ScoreboardModel, rhs: ScoreboardModel) -> Bool {
        return lhs.score == rhs.score
    }
    
    var description: String {
            if let playerName = player {
                return "Player: \(playerName), Score: \(score)"
            } else {
                return "Player: Unknown, Score: \(score)"
            }
        }
}
