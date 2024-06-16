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
    
    var user =  UserDefaultsService.shared.getCurrentUser()
    @State var showErrorAlert: Bool = false
    @State var errorMessage: String = ""
    @State var showAdminSettingsView: Bool = false
    @State var showChipsOnHand = false
    @State var showLeaderBoard = false
    
    @Binding var movePlayerId: UUID

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .center) {
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
                        
                        HStack {
                            Text("Move:")
                                .bold()
                            if (movePlayerId == user.id) {
                                Text("you")
                            } else {
                                Text("not you")
                            }
                        }
                    }
                    Spacer()
                    Button {
                        // leave room
                        Task {
                            do {
                                try await NetworkService.shared.leaveGameRoom(userId: user.id, roomId: gameRoom.id) { res in
                                    switch res {
                                    case .success(_):
                                        leaveRoom.toggle()
                                        if gameRoom.adminNickname == user.nickName {
                                            // Остановка
                                            Task {
                                                try await NetworkService.shared.changeGameStatus(gameStatus: GameStatus.End, roomId: gameRoom.id)
                                            }
                                        }
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
                        NetworkService.shared.stopGameRoomViewTimer()
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
                    
                    Button(action: {
                        showLeaderBoard.toggle()
                    }, label: {
                        Image(systemName: "star")
                    .padding()
                    .foregroundColor(.black)
                    })
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        showChipsOnHand.toggle()
                    }, label: { HStack {
                        Text("Chips on hand")
                        Image(systemName: "arrowshape.forward")
                    }.padding()
                            .background(RoundedRectangle(cornerRadius: 25)
                                .fill(Color.gray))
                            .foregroundColor(.white)
                    })
                }
            }.padding()
        }
        .fullScreenCover(isPresented: $leaveRoom) {
            // Переход на другой экран всех комнат
            AllGameRoomsView()
        }
        
        .sheet(isPresented: $showAdminSettingsView) {
            // Переход в настройки
            AdminSettingsView(viewModel: AdminSettingsViewModel(), roomId: $gameRoom.id)
        }
        .sheet(isPresented: $showChipsOnHand) {
            ChipsOnHand()
        }
        .sheet(isPresented: $showLeaderBoard) {
            let viewModel = ScoreboardViewModel(isPresented: $showLeaderBoard, roomId: gameRoom.id)
            ScoreboardView(viewModel: viewModel)
        }
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text(errorMessage), dismissButton: .default(Text("Ok")))
        })
    }
}

struct GameTopBar_Previews: PreviewProvider {
    static var previews: some View {
        GameTopBar(
            gameRoom: .constant(GameRoom(id: UUID(), adminNickname: "adminUser", roomCode: nil, gameStatus: GameStatus.NotStarted.rawValue, currentNumberOfChips: 100)),
            leaveRoom: .constant(false),
            movePlayerId: Binding<UUID>.constant(UUID())
        )
    }
}
