//
//  AllGameRoomsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import SwiftUI

struct AllGameRoomsView: View {
    @State var gameRooms: [GameRoom] = [GameRoom]()
//    @State var user: User = AuthService.shared.currentUser
    @State var currentGameRoom: GameRoom? = nil

    @State var showErrorAlert: Bool = false
    @State var errorMessage: String = ""
    
    @State var showPasswordAlert: Bool = false
    @State var showGameRoom: Bool = false
    
    @Binding var user: User
    @State var showCreateGameRoomView: Bool = false
    @State var tappedGameRoom: GameRoom? = nil

    @State var enteredRoomCode: String = ""
    @State var correctRoomCode: String = ""
    
//    @ObservedObject var viewModel: AllGameRoomsViewModel = AllGameRoomsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Create new room", systemImage: "plus") {
                    showCreateGameRoomView.toggle()
                }

                if !gameRooms.isEmpty {
                    List {
                        ForEach(gameRooms) { gameRoom in
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
                                onTapGesture(selectedGameRoom: gameRoom)
                                tappedGameRoom = gameRoom
                            }
                        }
                    }
                }
                else {
                    Spacer()
                    Text("There are no rooms")
                        .font(.title)
                    Spacer()
                }
            }
        }
        
        .fullScreenCover(isPresented: $showGameRoom) {
            if let room = currentGameRoom {
                GameRoomView(gameRoom: room , user: $user)
            }
        }
        
        .fullScreenCover(isPresented: $showCreateGameRoomView) {
            CreateGameRoomView(user: .constant(user))
        }
        
        .alert("Enter room code", isPresented: $showPasswordAlert) {
            SecureField("Room code", text: $enteredRoomCode)
            Button("OK") {
                enterPassword(enteredRoomCode: enteredRoomCode, tappedRoom: tappedGameRoom!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This room is private. Please, enter the room code")
        }
        
        
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(
                title: Text(errorMessage),
                dismissButton: .default(Text("Ok"))
            )
        })
        
        .onAppear {
            onAppear()
        }
    }
    
    func onAppear() {
            Task {
                do {
                    if let fetchedGameRooms = try await NetworkService.shared.getAllGameRooms() {
                        self.gameRooms = fetchedGameRooms
                    }
                }
                catch {
                    showErrorAlert.toggle()
                    errorMessage = "Произошла ошибка при получении комнат"
                }
            }
        }
        
        func onTapGesture(selectedGameRoom: GameRoom) {
            if shouldShowPasswordAllert(selectedGameRoom: selectedGameRoom) {
                showPasswordAlert.toggle()
            } else {
                // Пытаемся добавить пользователя в комнату.
                addUserIntoRoom(selectedGameRoom: selectedGameRoom)
            }
        }

        
        func enterPassword(enteredRoomCode: String, tappedRoom: GameRoom) {
            if checkRoomCode(enteredRoomCode: enteredRoomCode, correctRoomCode: tappedRoom.roomCode!) {
                addUserIntoRoom(selectedGameRoom: tappedRoom)
            } else {
                showErrorAlert.toggle()
                errorMessage = "Неверный пароль"
            }
        }
        
        // MARK: Проверка введенного пароля.
        private func shouldShowPasswordAllert(selectedGameRoom: GameRoom) -> Bool {
            if let code = selectedGameRoom.roomCode {
                if code.isEmpty || (user.nickName == selectedGameRoom.adminNickname) {
                    return false
                } else {
                    return true
                }
            }
            return false
        }
        
        // MARK: Проверка введенного пароля.
        private func checkRoomCode(enteredRoomCode: String, correctRoomCode: String) -> Bool {
            if enteredRoomCode == correctRoomCode {
                return true;
            }
            return false;
        }
        
        
        // MARK: Добавление пользователя в комнату.
        private func addUserIntoRoom(selectedGameRoom: GameRoom) {
            Task {
                do {
                    try await NetworkService.shared.addGamerIntoRoom(gamerId: user.id, roomId: selectedGameRoom.id)
                    showGameRoom.toggle()
                    currentGameRoom = selectedGameRoom
                } catch {
                    showErrorAlert.toggle()
                    errorMessage = "Произошла ошибка при добавлении пользователя в комнату"
                }
            }
        }
    
//    func checkPassword(enteredRoomCode: String, correctRoomCode: String) -> Bool {
//        if enteredRoomCode == correctRoomCode {
//            return true;
//        }
//        return false;
//    }
}

//#Preview {
//    AllGameRoomsView(user: .constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F6B")!, nickName: "nick")))
//}
