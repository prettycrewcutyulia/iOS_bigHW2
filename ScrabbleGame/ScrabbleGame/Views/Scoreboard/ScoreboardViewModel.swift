//
//  ScoreboardViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import Foundation
import SwiftUI

class ScoreboardViewModel: ObservableObject {
    @Published var scoreboardModels: [ScoreboardModel] = []
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func onAppear() {
        // запрос в сервис
        scoreboardModels = [ScoreboardModel(player: "ivan", score: 10)]
        print("Запрос в сервис")
    }
    
    func onButtonDoneTap() {
        isPresented.toggle()
        print("Закрыть экран")
    }
}
