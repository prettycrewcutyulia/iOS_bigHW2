//
//  AdminSettingsViewModel.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 17.06.2024.
//

import Foundation

class AdminSettingsViewModel: ObservableObject {
    @Published var allGamersIntoRoom: [User] = [User]()
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func onAppear(roomId: UUID) {
            Task {
                do {
                    if let gamers = try await NetworkService.shared.getAllGamersIntoRoom(roomId: roomId) {
                        self.allGamersIntoRoom = gamers
                    } else {
                        errorMessage = "Произошла ошибка при получении игроков"
                    }
                }
                catch {
                    showErrorAlert.toggle()
                    errorMessage = "Произошла ошибка при получении игроков"
                }
            }
    }
    
    func deleteGamerFromRoom(gamerId: UUID, roomId: UUID) {
        Task {
            do {
                try await NetworkService.shared.leaveGameRoom(userId: gamerId, roomId: roomId) { res in
                    switch res {
                    case .success(_): break
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                        self.showErrorAlert.toggle()
                    }
                }

            } catch {
                errorMessage = "Произошла ошибка при удалении игрока"
                showErrorAlert.toggle()
            }
        }
    }
}
