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
    let roomUUID: UUID
    
    init(isPresented: Binding<Bool>, roomId: UUID) {
        self._isPresented = isPresented
        roomUUID = roomId
    }
    
    func onAppear() {
        Task {
            if let scoreboardRequest = await NetworkService.shared.fetchLeaderboard(forRoomId: roomUUID) {
                scoreboardModels = scoreboardRequest
            }
        }
        print("Запрос в сервис")
        
    }
    
    func onButtonDoneTap() {
        isPresented.toggle()
        print("Закрыть экран")
    }
}
