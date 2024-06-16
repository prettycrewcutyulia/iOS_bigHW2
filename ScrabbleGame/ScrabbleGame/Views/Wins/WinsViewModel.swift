//
//  WinsViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import Foundation
import SwiftUI

class WinsViewModel: ObservableObject {

    @Published var scoreboardModels: [ScoreboardModel] = []
    @Published var navigateToNextScreen = false

    let nextScreen = AllGameRoomsView(user: Binding<User>.constant(User(id: UUID(uuidString: "ab6bd7f5-b309-4048-a678-90e6d6fd02a1")!, nickName: "IRINA")))
    
    init() {
        onAppear()
    }

    func onAppear() {
        // запрос в сервис
        scoreboardModels = [ScoreboardModel(player: "ivan", score: 10)]
        print("Запрос в сервис")
    }
    
    func onButtonDoneTap() {
        print("Закрыть этот экран")
        print("Открыть начальный экран")
        navigateToNextScreen = true
    }
}
