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
    @Binding var chipsOnHand: [Chip]
    
    @State var leaveRoom: Bool = false
    
    @State var buttonText: String = ""
    @State var buttonColor: Color = .black
    @State var showErrorAlert: Bool = false


    var body: some View {
        NavigationStack {
            // TODO: В зависимости от того админ или нет показывать тот или иной экран
            GameTopBar(gameRoom: $gameRoom, leaveRoom: $leaveRoom, chipsOnHand: $chipsOnHand, user: $user)
            Spacer()
            
            if gameRoom.gameStatus.lowercased() == GameStatus.Running.rawValue.lowercased() {
                ChipField(chips: Binding<[ChipsOnField]>.constant([]))
            }
            
            // Кнопка старата/паузы игры доступна только админу
            if user.nickName == gameRoom.adminNickname {
                CustomButton(buttonText: $buttonText, buttonColor:  $buttonColor, isDisabled: false) {
                    changeGameStatus(buttonText: buttonText)
                }
                .padding()
            }
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
                    self.buttonText = GameButtonText.StartGame.rawValue
                    self.buttonColor = .black
                    showErrorAlert.toggle()
                }
            }
        } else {
            self.buttonText = GameButtonText.StartGame.rawValue
            self.buttonColor = .black
            Task {
                do {
                    gameRoom = try await NetworkService.shared.changeGameStatus(gameStatus: .Pause, roomId: gameRoom.id)
                }
                catch {
                    self.buttonText = GameButtonText.PauseGame.rawValue
                    self.buttonColor = .gray
                    showErrorAlert.toggle()
                }
            }
        }
    }
}
