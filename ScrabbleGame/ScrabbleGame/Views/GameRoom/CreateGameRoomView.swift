//
//  CreateGameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct CreateGameRoomView: View {
    @Binding var adminNickname: String
    @State var roomCode: String = ""
    @State var gameRoom: GameRoom? = nil
    @State var showGameRoom: Bool = false
    @State var showErrorAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(adminNickname),\ncreate game room")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                CustomTextView(variable: $roomCode, placeholderName: "Enter room code")
                
                Spacer()
                
                NextButtonView(isDisabled: roomCode.isEmpty) {
                    // запрос
                    Task {
                        do {
                            gameRoom = try await NetworkService.shared.createGameRoom(adminNickname: adminNickname, roomCode: roomCode)
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
                GameRoomView(gameRoom: Binding.constant(unwrappedGameRoom))
            }
        }
    }
}

#Preview {
    CreateGameRoomView(adminNickname: Binding<String>.constant("Irina"))
}
