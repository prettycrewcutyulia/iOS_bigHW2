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

struct GameTopBar: View {
    @Binding var gameRoom: GameRoom
    @Binding var leaveRoom: Bool
    
    @Binding var user: User
    @State var showErrorAlert: Bool = false
    @State var errorMessage: String = ""
    @State var showAdminSettingsView: Bool = false

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
                    LetterInTileCounterView(count: $gameRoom.currentNumberOfChips)
                    Spacer()
                    Button {
                        // leave room
                        Task {
                            do {
                                try await NetworkService.shared.leaveGameRoom(userId: user.id, roomId: gameRoom.id) { res in
                                    switch res {
                                    case .success(_):
                                        leaveRoom.toggle()
                                    case .failure(let failure):
                                        print(failure.localizedDescription)
                                        showErrorAlert.toggle()
                                        errorMessage = failure.localizedDescription
                                    }
                                }
                            }
                            catch {
                                print("error")
                            }
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right")
                            .foregroundStyle(.black)
                    }
                    if (gameRoom.adminNickname == user.nickName) {
                        Button {
                            // delete room
                            Task {
                                do {
                                    try await NetworkService.shared.deleteRoomById(roomId: gameRoom.id) { res in
                                        switch res {
                                        case .success(_):
                                            leaveRoom.toggle()
                                        case .failure(let failure):
                                            print(failure.localizedDescription)
                                            showErrorAlert.toggle()
                                            errorMessage = failure.localizedDescription
                                        }
                                    }
                                }
                                catch {
                                    print("error")
                                }
                            }
                        } label: {
                            Image(systemName: "multiply")
                                .foregroundStyle(.red)
                        }
                    }
                    
                    if user.nickName == gameRoom.adminNickname {
                        Button {
                            showAdminSettingsView.toggle()
                            
                        } label: {
                            Image(systemName: "person")
                                .foregroundStyle(.black)
                        }
                    }
                    Spacer()
                    
                }
            }
        }
        .fullScreenCover(isPresented: $leaveRoom) {
            // Переход на другой экран всех комнат
            AllGameRoomsView(user: $user)
        }
        
        .sheet(isPresented: $showAdminSettingsView) {
            // Переход в настройки
            AdminSettingsView(roomId: $gameRoom.id)
        }
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text(errorMessage), dismissButton: .default(Text("Ok")))
        })
    }
}
//
//#Preview {
//    GameRoomView(gameRoom: (GameRoom(id: "gameID", adminNickname: "adminNickName", roomCode: "roomCode", gameStatus: "Not started", currentNumberOfChips: 0)), user: <#Binding<User>#>)
//}
