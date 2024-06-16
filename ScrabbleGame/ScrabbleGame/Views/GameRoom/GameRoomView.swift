//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @State var gameRoom: GameRoom
    @Binding var user: User
    
    @State var leaveRoom: Bool = false
    
    @State var buttonText: String = ""
    @State var buttonColor: Color = .green
    @State var showErrorAlert: Bool = false


    var body: some View {
        NavigationStack {
            // TODO: В зависимости от того админ или нет показывать тот или иной экран
            GameTopBar(gameRoom: $gameRoom, leaveRoom: $leaveRoom, user: $user)
            Spacer()
            
            // Кнопка старата/паузы игры доступна только админу
            if user.nickName == gameRoom.adminNickname {
                CustomButton(buttonText: $buttonText, buttonColor:  $buttonColor, isDisabled: false) {
                    changeGameStatus(buttonText: buttonText)
                }
            }
            Spacer()
        }
        .onAppear {
            getButtonValue()
        }
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text("Произошла ошибка при смене статуса игры"), dismissButton: .default(Text("Ok")))
        })
    }
    
    func getButtonValue() {
        if gameRoom.gameStatus.lowercased() == GameStatus.Running.rawValue.lowercased() {
            buttonText = GameButtonText.PauseGame.rawValue
        } else {
            buttonText = GameButtonText.StartGame.rawValue
        }
    }
    
    // MARK: Смена статуса игры.
    func changeGameStatus(buttonText: String) {
        if buttonText == GameButtonText.StartGame.rawValue {
            self.buttonText = GameButtonText.PauseGame.rawValue
            self.buttonColor = .gray
            Task {
                do {
                    gameRoom = try await NetworkService.shared.changeGameStatus(gameStatus: .Running, roomId: gameRoom.id)
                }
                catch {
                    showErrorAlert.toggle()
                }
            }
        } else {
            self.buttonText = GameButtonText.StartGame.rawValue
            self.buttonColor = .green
            Task {
                do {
                    gameRoom = try await NetworkService.shared.changeGameStatus(gameStatus: .Pause, roomId: gameRoom.id)
                }
                catch {
                    showErrorAlert.toggle()
                }
            }
        }
    }
}
