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
    @Binding var chipsOnHand: [Chip]
    
    @Binding var user: User
    @State var showErrorAlert: Bool = false
    @State var errorMessage: String = ""
    @State var showAdminSettingsView: Bool = false
    @State var showChipsOnHand = false

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
                }
                
                HStack {
                    LetterInTileCounterView(count: $gameRoom.currentNumberOfChips)
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
            AllGameRoomsView(user: $user)
        }
        
        .sheet(isPresented: $showAdminSettingsView) {
            // Переход в настройки
            AdminSettingsView(roomId: $gameRoom.id)
        }
        .sheet(isPresented: $showChipsOnHand) {
            ChipsOnHand(chipsOnHand: $chipsOnHand)
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
            leaveRoom: .constant(false), chipsOnHand: Binding<[Chip]>.constant([]),
            user: .constant(User(id: UUID(), nickName: "NICK"))
        )
    }
}
