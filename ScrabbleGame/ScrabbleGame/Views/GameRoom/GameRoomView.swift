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
    
    @State var buttonText: String = GameButtonText.StartGame.rawValue
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
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text("Произошла ошибка при смене статуса игры"), dismissButton: .default(Text("Ok")))
        })
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

struct GameTopBar: View {
    @Binding var gameRoom: GameRoom
    @Binding var leaveRoom: Bool
    
    @Binding var user: User

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Game status:")
                                .bold()
                            Text("\(gameRoom.gameStatus)")
                                .foregroundStyle(gameRoom.gameStatus == GameStatus.NotStarted.rawValue ? .gray : gameRoom.gameStatus == GameStatus.Running.rawValue ? .green : gameRoom.gameStatus == GameStatus.Pause.rawValue ? .gray : .red)
                        }
                        HStack {
                            Text("Room admin:")
                                .bold()
                            if (gameRoom.adminNickname == user.nickName) {
                                Text("you")
                            } else {
                                Text("\(gameRoom.adminNickname)")
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    HStack {
                        Text("\(gameRoom.currentNumberOfChips)")
                            .foregroundStyle(gameRoom.currentNumberOfChips == 0 ? .red : .green)
                        Image(systemName: "dollarsign.circle")
                            .foregroundStyle(.yellow)
                        
                    }
                    Spacer()
                    Button {
                        // TODO: leave room
                        Task {
                            do {
                                var t = try await NetworkService.shared.leaveGameRoom(userId: user.id, roomId: gameRoom.id)
                                print(t)
                            }
                            catch {
                                print("error")
                            }
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right")
                            .foregroundStyle(.black)
                    }
                    Spacer()
                    
                }
            }
        }
        .fullScreenCover(isPresented: $leaveRoom) {
            // TODO: Переход на другой экран всех комнат
            Text("You lived room")
        }
    }
}

//#Preview {
//    GameRoomView(gameRoom: (GameRoom(id: "gameID", adminNickname: "adminNickName", roomCode: "roomCode", gameStatus: "Not started", currentNumberOfChips: 0)))
//}
