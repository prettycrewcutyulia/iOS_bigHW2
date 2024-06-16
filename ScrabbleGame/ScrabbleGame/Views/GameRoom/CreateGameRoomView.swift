//
//  CreateGameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct CreateGameRoomView: View {
    private var user: User = UserDefaultsService.shared.getCurrentUser()
    
    @State var roomCode: String = ""
    @State var gameRoom: GameRoom? = nil
    
    @State var showGameRoom: Bool = false
    @State var showErrorAlert: Bool = false
    @State var isRoomPrivate: Bool = false
    @State var isRoomPublic: Bool = false
    @State var chipsOnHand: [Chip] = []

    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(user.nickName),\ncreate game room")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Toggle(isOn: $isRoomPublic) {
                    Text("Create public room")
                }
                .frame(width: 340, height: 61)
                .toggleStyle(SwitchToggleStyle(tint: .black))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isRoomPublic ? .black : .gray, lineWidth: isRoomPublic ? 0.5 : 0.2)
                        .frame(width: 370)
                )
                .onChange(of: isRoomPublic) {
                    if isRoomPublic {
                        isRoomPrivate = false
                    }
                }
                .padding(.bottom, 20)
                
                Toggle(isOn: $isRoomPrivate) {
                    Text("Create private room")
                }
                .frame(width: 340, height: 61)
                .toggleStyle(SwitchToggleStyle(tint: .black))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isRoomPrivate ? .black : .gray, lineWidth: isRoomPrivate ? 0.5 : 0.2)
                        .frame(width: 370)
                )
                .onChange(of: isRoomPrivate) {
                    if isRoomPrivate {
                        isRoomPublic = false
                    }
                }
                .padding(.bottom, 20)
                
                if isRoomPrivate {
                    CustomTextView(variable: $roomCode, placeholderName: "Enter room code")
                }
                
                Spacer()
                
                CustomButton(buttonText: Binding<String>.constant("Next"), buttonColor: Binding<Color>.constant(.black), isDisabled: isRoomPublic ? false : roomCode.isEmpty) {
                    // запрос
                    Task {
                        do {
                            gameRoom = try await NetworkService.shared.createGameRoom(adminNickname: user.nickName, roomCode: roomCode)
                            try await NetworkService.shared.addGamerIntoRoom(gamerId: user.id, roomId: gameRoom!.id)
                            showGameRoom.toggle()
                        } catch {
                            showErrorAlert.toggle()
                        }
                    }
                }
                
            }
        }
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text("Произошла ошибка при создании комнаты"), dismissButton: .default(Text("Ok")))
        })
        .fullScreenCover(isPresented: $showGameRoom) {
            if let unwrappedGameRoom = gameRoom {
                let viewModel: GameRoomViewModel = GameRoomViewModel(gameRoom: unwrappedGameRoom)
                GameRoomView(viewModel: viewModel)
            }
        }
    }
}

//#Preview {
//    CreateGameRoomView(adminNickname: Binding<String>.constant("Irina"))
//}
