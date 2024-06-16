//
//  GameTabBarView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

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
                    
                    if user.nickName == gameRoom.adminNickname {
                        Button {
                            showAdminSettingsView.toggle()
                            
                        } label: {
                            Image(systemName: "pencil")
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
