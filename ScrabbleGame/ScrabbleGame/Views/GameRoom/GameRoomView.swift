//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @Binding var gameRoom: GameRoom
    
    var body: some View {
        Text("\(gameRoom.adminNickname), \(gameRoom.currentNumberOfChips), \(gameRoom.gameStatus), \(gameRoom.roomCode)")
    }
}

#Preview {
    GameRoomView(gameRoom: Binding<GameRoom>.constant(GameRoom(id: "gameID", adminNickname: "adminNickName", roomCode: "roomCode", gameStatus: "gamestatus", currentNumberOfChips: 0)))
}
