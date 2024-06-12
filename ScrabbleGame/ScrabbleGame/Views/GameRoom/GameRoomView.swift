//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @Binding var gameRoom: GameRoom
    @State var leaveRoom: Bool = false
    
    @State var buttonText: String = GameButtonText.StartGame.rawValue
    @State var buttonColor: Color = .green
    
    var body: some View {
        NavigationStack {
            GameTopBar(gameRoom: $gameRoom, leaveRoom: $leaveRoom)
            Spacer()
            ButtonView(buttonText: $buttonText, buttonColor:  $buttonColor, isDisabled: false) {
                changeGameStatus(buttonText: buttonText)
                // TODO: записать в бд статус комнаты
            }
            Spacer()
        }
    }
    
    func changeGameStatus(buttonText: String) {
        if buttonText == GameButtonText.StartGame.rawValue {
            self.buttonText = GameButtonText.PauseGame.rawValue
            self.buttonColor = .gray
            // Менять статус игры
        } else {
            self.buttonText = GameButtonText.StartGame.rawValue
            self.buttonColor = .green
            // Менять статус игры

        }
    }
}

enum GameButtonText: String {
    case StartGame = "Start game"
    case PauseGame = "Pause game"
}

struct GameTopBar: View {
    @Binding var gameRoom: GameRoom
    @Binding var leaveRoom: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Game status:")
                                .bold()
                            Text("\(gameRoom.gameStatus)")
                                .foregroundStyle(gameRoom.gameStatus == "Not started" ? .gray : gameRoom.gameStatus == "Started" ? .green : .red)
                        }
                        HStack {
                            Text("Room admin:")
                                .bold()
                            Text("\(gameRoom.adminNickname)")
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

#Preview {
    GameRoomView(gameRoom: Binding<GameRoom>.constant(GameRoom(id: "gameID", adminNickname: "adminNickName", roomCode: "roomCode", gameStatus: "Not started", currentNumberOfChips: 0)))
}
