//
//  enums.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import Foundation

enum GameButtonText: String {
    case StartGame = "Start game"
    case PauseGame = "Pause game"
}

enum GameStatus: String {
    case NotStarted = "Not started" // default value
    case Running = "Running"
    case Pause = "Pause"
    case End = "End"
}
