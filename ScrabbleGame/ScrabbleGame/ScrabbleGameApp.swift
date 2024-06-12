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
            CreateGameRoomView(adminNickname: Binding<String>.constant("irina"))
        }
    }
}
