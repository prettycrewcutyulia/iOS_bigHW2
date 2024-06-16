//
//  AllGameRoomsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 15.06.2024.
//

import SwiftUI

struct AllGameRoomsView: View {
    @Binding var user: User
//    @State var selectedGameRoom: GameRoom? = nil

//    @State var gameRooms: [GameRoom]? = nil
    
//    @State var showErrorAlert: Bool = false
//    @State var showPasswordAlert: Bool = false
//    @State var showGameRoom: Bool = false
    @State var showCreateGameRoomView: Bool = false
    @State var tappedGameRoom: GameRoom? = nil

    
    @State var enteredRoomCode: String = ""
    @State var correctRoomCode: String = ""
    
    @ObservedObject var viewModel: AllGameRoomsViewModel = AllGameRoomsViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Button("Create new room", systemImage: "plus") {
                    showCreateGameRoomView.toggle()
                }
                if let rooms = viewModel.gameRooms {
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
                                viewModel.onTapGesture(selectedGameRoom: gameRoom)
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
        
        .fullScreenCover(isPresented: $viewModel.showGameRoom) {
            GameRoomView(gameRoom: viewModel.currentGameRoom!, user: $user)
        }
        
        .fullScreenCover(isPresented: $showCreateGameRoomView) {
            CreateGameRoomView(user: .constant(user))
        }
        
        .alert("Enter room code", isPresented: $viewModel.showPasswordAlert) {
            SecureField("Room code", text: $enteredRoomCode)
            Button("OK") {
                viewModel.enterPassword(enteredRoomCode: enteredRoomCode, tappedRoom: tappedGameRoom!)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This room is private. Please, enter the room code")
        }
        
        
        .alert(isPresented: $viewModel.showErrorAlert, content: {
            return Alert(
                title: Text(viewModel.errorMessage),
                dismissButton: .default(Text("Ok"))
            )
        })
        
        .onAppear {
            viewModel.onAppear()
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
