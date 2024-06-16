//
//  ScrabbleGameApp.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

@main
struct ScrabbleGameApp: App {
    var body: some Scene {
        WindowGroup {
            // При вызове данного view - передавать никнэйм админа. Сейчас это заглушка.
//            CreateGameRoomView(adminNickname: Binding<String>.constant("irina"), user: Binding<User>.constant(User(id: "0")))
//            AllGameRoomsView(user: Binding<User>.constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F7B")!, nickName: "nbb")))
            
            ScoreboardView()
        }
    }
}
