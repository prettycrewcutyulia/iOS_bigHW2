//
//  AllGameRoomsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import SwiftUI

struct AllGameRoomsView: View {
    @Binding var user: User
    @State var selectedGameRoom: GameRoom? = nil

    @State var gameRooms: [GameRoom]? = nil
    
    @State var showErrorAlert: Bool = false
    @State var showPasswordAlert: Bool = false
    @State var showGameRoom: Bool = false
    @State var showCreateGameRoomView: Bool = false


    
    @State var enteredRoomCode: String = ""
    @State var correctRoomCode: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Button("Create new room", systemImage: "plus") {
                    showCreateGameRoomView.toggle()
                }
                if let rooms = gameRooms {
                    List {
                        ForEach(rooms) { gameRoom in
                            HStack {
                                if (user.nickName == gameRoom.adminNickname) {
                                    HStack {
                                        Text("This is your room, ")
                                            .bold()
                                            .foregroundStyle(.green)
                                        Text("\(gameRoom.gameStatus)")
                                    }
                                } else {
                                    Text("Room by \(gameRoom.adminNickname), \(gameRoom.gameStatus)")
                                }
                                Spacer()
                                if let code = gameRoom.roomCode {
                                    if (!code.isEmpty) {
                                        Image(systemName: "lock.fill")
                                            .foregroundStyle(user.nickName == gameRoom.adminNickname ? .green : .black)
                                    }
                                }
                            }
                            .onTapGesture {
                                if let code = gameRoom.roomCode {
                                    if code.isEmpty || (user.nickName == gameRoom.adminNickname) {
                                        // Просто переход в комнату
                                        addUserIntoRoom()
                                        showGameRoom.toggle()
                                        selectedGameRoom = gameRoom
                                    } else {
                                        // Справшиваем пароль
                                        showPasswordAlert.toggle()
                                        correctRoomCode = code
                                        selectedGameRoom = gameRoom
                                    }
                                }
                                
                            }
                        }
                    }
                }
                else {
                    Text("There are no rooms")
                }
            }
        }
        
        .fullScreenCover(isPresented: $showGameRoom) {
            GameRoomView(gameRoom: selectedGameRoom!, user: $user)
        }
        
        .fullScreenCover(isPresented: $showCreateGameRoomView) {
            CreateGameRoomView(user: .constant(user))
        }
        
        .alert("Enter room code", isPresented: $showPasswordAlert) {
            SecureField("Room code", text: $enteredRoomCode)
            Button("OK") {
                if checkPassword(enteredRoomCode: enteredRoomCode, correctRoomCode: correctRoomCode)
                {
                    addUserIntoRoom()
                    showGameRoom.toggle()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This room is private. Please, enter the room code")
        }
        
        
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text("Произошла при получении комнат"), dismissButton: .default(Text("Ok")))
        })
        
        .onAppear {
            Task {
                do {
                    gameRooms = try await NetworkService.shared.getAllGameRooms()
                }
                catch {
                    showErrorAlert.toggle()
                }
            }
        }
    }
    
    func checkPassword(enteredRoomCode: String, correctRoomCode: String) -> Bool {
        if enteredRoomCode == correctRoomCode {
            return true;
        }
        return false;
    }
    
    func addUserIntoRoom() {
        Task {
            do {
                if let gameRoomId = selectedGameRoom?.id {
                    try await NetworkService.shared.addGamerIntoRoom(gamerId: user.id, roomId: gameRoomId)
                } else {
                    showErrorAlert.toggle()
                }
            } catch {
                showErrorAlert.toggle()
            }
        }
    }
}

#Preview {
    AllGameRoomsView(user: .constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F6B")!, nickName: "nick")))
}
