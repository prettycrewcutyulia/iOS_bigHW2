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

    let nextScreen = AllGameRoomsView()
    
    init() {
        onAppear()
    }

    func onAppear() {
        // запрос в сервис
        Task {
            do {
                scoreboardModels = await NetworkService.shared.fetchLeaderboard(forRoomId: UserDefaultsService.shared.getCurrentUserSafe()?.id ?? UUID()) ?? []
            }
        }
    }
    
    func onButtonDoneTap() {
        navigateToNextScreen = true
    }
}
