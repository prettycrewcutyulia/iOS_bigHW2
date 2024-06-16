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

    let nextScreen = AllGameRoomsView(user: Binding<User>.constant(User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F7B")!, nickName: "nbb")))
    
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
