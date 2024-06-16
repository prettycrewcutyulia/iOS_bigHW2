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
//            AllGameRoomsView(user: Binding<User>.constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F9B")!, nickName: "nbkkkb")))
            
            AllGameRoomsView(user: Binding<User>.constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F2B")!, nickName: "n2bkkkb")))
//            ChipField(chips: .constant([
//                ChipsOnField(id: UUID(), coordinate: Coordinate(x: "H", y: 8), chip: Chip(alpha: "A", point: 1)),
//                ChipsOnField(id: UUID(), coordinate: Coordinate(x: "I", y: 8), chip: Chip(alpha: "B", point: 3))
//            ]))
            
        }
    }
}
