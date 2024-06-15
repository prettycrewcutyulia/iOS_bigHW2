//
//  GameRoom.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import Foundation

struct GameRoom: Identifiable, Codable {
    let id: String
    let adminNickname: String
    let roomCode: String?
    var gameStatus: String
    var currentNumberOfChips: Int
}
