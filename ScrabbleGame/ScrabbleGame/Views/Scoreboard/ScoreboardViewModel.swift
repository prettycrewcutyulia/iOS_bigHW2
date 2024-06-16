//
//  ScoreboardViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import Foundation

class ScoreboardViewModel: ObservableObject {
    @Published var scoreboardModels: [ScoreboardModel] = []
    
    func onAppear() {
        // запрос в сервис
        scoreboardModels = [ScoreboardModel(player: "ivan", score: 10)]
        print("Запрос в сервис")
    }
    
    func onButtonDoneTap() {
        // Закрыть экран
        print("Закрыть экран")
    }
}
