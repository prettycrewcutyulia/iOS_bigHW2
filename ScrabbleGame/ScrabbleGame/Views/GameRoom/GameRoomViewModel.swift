//
//  GameRoomViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation
import SwiftUI
import Combine

class GameRoomViewModel: ObservableObject {
    @Published var buttonText: String = ""
    @Published var buttonColor: Color = .black
    @Published var showErrorAlert: Bool = false
    @Published var showWinView: Bool = false
    @Published var leaveRoom: Bool = false
    @Published var user = UserDefaultsService.shared.currentUser
    @Published var movePlayerId: UUID = UUID()
    @Published var countChipsInTile: Int = 0
    @Published var chipsOnField: [ChipsOnField] = []
    @Published var disabledMove: Bool = false
    
    @Published var gameRoom: GameRoom
    
    // Сет для хранения подписок
    private var cancellables = Set<AnyCancellable>()
    
    init(gameRoom: GameRoom) {
        self.gameRoom = gameRoom

        NetworkService.shared.getMoveEvent.sink{ [weak self] id in
            self?.movePlayerId = id
            if self?.movePlayerId == self?.user.id {
                self?.disabledMove = true
            }
        }.store(in: &cancellables)
        
        NetworkService.shared.getCountChipsInTileEvent.sink{ [weak self] count in
            self?.countChipsInTile = count
        }.store(in: &cancellables)
        
        NetworkService.shared.getChipsOnFieldEvent.sink{ [weak self] chips in
            self?.chipsOnField = chips
        }.store(in: &cancellables)
        
        NetworkService.shared.getRoomStatusEvent.sink{ [weak self] status in
            DispatchQueue.main.async {
                self?.gameRoom.gameStatus = status
                if self?.gameRoom.gameStatus.lowercased() == GameStatus.End.rawValue.lowercased() {
                    self?.showWinView.toggle()
                }
            }
        }.store(in: &cancellables)
        // Тут буду получать данные
        // Чей ход + кол-во фишек в мешке + элементы на карте
        
        NetworkService.shared.startGameRoomViewTimer()
        NetworkService.shared.startGameRoomStatusTimer(roomId: gameRoom.id)
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
                    DispatchQueue.main.async {
                        self.buttonText = GameButtonText.StartGame.rawValue
                        self.buttonColor = .black
                        self.showErrorAlert.toggle()
                    }
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
                    DispatchQueue.main.async {
                        self.buttonText = GameButtonText.PauseGame.rawValue
                        self.buttonColor = .gray
                        self.showErrorAlert.toggle()
                    }
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
