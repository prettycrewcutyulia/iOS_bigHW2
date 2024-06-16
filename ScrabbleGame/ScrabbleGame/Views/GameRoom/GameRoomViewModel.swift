//
//  GameRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation
import SwiftUI

class GameRoomViewModel: ObservableObject {
    
    @Published var buttonText: String = ""
    @Published var buttonColor: Color = .black
    @Published var showErrorAlert: Bool = false
    @Published var leaveRoom: Bool = false
    @Published var user = AuthService.shared.currentUser
    
    @Published var chipsOnHand: [Chip] = []
    @Published var gameRoom: GameRoom
    
    init(gameRoom: GameRoom) {
        self.gameRoom = gameRoom
    }
    
    // MARK: Смена статуса игры.
    func changeGameStatus(buttonText: String) {
        if buttonText == GameButtonText.StartGame.rawValue {
            self.buttonText = GameButtonText.PauseGame.rawValue
            self.buttonColor = .gray
            Task {
                do {
                    self.gameRoom = try await NetworkService.shared.changeGameStatus(gameStatus: .Running, roomId: gameRoom.id)
                }
                catch {
                    self.buttonText = GameButtonText.StartGame.rawValue
                    self.buttonColor = .black
                    self.showErrorAlert.toggle()
                }
            }
        } else {
            self.buttonText = GameButtonText.StartGame.rawValue
            self.buttonColor = .black
            Task {
                do {
                    self.gameRoom = try await NetworkService.shared.changeGameStatus(gameStatus: .Pause, roomId: gameRoom.id)
                }
                catch {
                    self.buttonText = GameButtonText.PauseGame.rawValue
                    self.buttonColor = .gray
                    self.showErrorAlert.toggle()
                }
            }
        }
    }
    
    func getButtonValue() {
        if gameRoom.gameStatus.lowercased() == GameStatus.Running.rawValue.lowercased() {
            buttonText = GameButtonText.PauseGame.rawValue
        } else {
            buttonText = GameButtonText.StartGame.rawValue
        }
    }
    
}
