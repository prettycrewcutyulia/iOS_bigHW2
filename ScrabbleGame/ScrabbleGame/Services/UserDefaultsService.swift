//
//  AuthService.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 16.06.2024.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private init() {}
    
    // TODO: Кто делает авторизацию - сюда присваивать текущего пользователя.
    var currentUser: User {
        return User(id: UUID(uuidString: "38B6A72A-4580-4736-B3EE-C33D3B060F7B")!, nickName: "irina")
    }
    
    // MARK: - Save and get to/from userDefaults current game id.
    func saveCurrentGameId(id: String) {
        UserDefaults.standard.set(id, forKey: "currentGameId")
    }
    
    func getCurrentGameId() -> String? {
        if let id = UserDefaults.standard.string(forKey: "currentGameId") {
            return id
        }
        return nil
    }
    
    // Сохранение массива карточек
        func saveCards(_ cards: [Chip]) {
            let encoder = JSONEncoder()
            if let encodedCards = try? encoder.encode(cards) {
                UserDefaults.standard.set(encodedCards, forKey: "currentChip")
            }
        }
        
        // Получение массива карточек
        func getCards() -> [Chip]? {
            if let savedCardsData = UserDefaults.standard.data(forKey: "currentChip") {
                let decoder = JSONDecoder()
                if let loadedCards = try? decoder.decode([Chip].self, from: savedCardsData) {
                    return loadedCards
                }
            }
            return nil
        }
}