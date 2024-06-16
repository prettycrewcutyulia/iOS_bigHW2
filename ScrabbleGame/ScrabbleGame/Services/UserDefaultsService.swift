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
    
    func getCurrentUser() -> User {
        getCurrentUserSafe()!
    }
    
    func getCurrentUserSafe() -> User? {
        if (currentUser == nil) {
            let id = UserDefaults.standard.string(forKey: "currentUserId")
            let nickName = UserDefaults.standard.string(forKey: "currentUserNickName")
            let token = UserDefaults.standard.string(forKey: "currentUserToken")
            if (id == nil || nickName == nil || token == nil) {
                return nil
            }
            currentUser = User(id: UUID(uuidString: id!)!, nickName: nickName!, token: token!)
        }
        return currentUser
    }
    
    func isCurrentUserSaved() -> Bool {
        let id = UserDefaults.standard.string(forKey: "currentUserId")
        return id != nil
    }

    private var currentUser: User?

    func setCurrentUser(id: String, nickName: String, token: String, password: String) {
        UserDefaults.standard.set(id, forKey: "currentUserId")
        UserDefaults.standard.set(nickName, forKey: "currentUserNickName")
        UserDefaults.standard.set(token, forKey: "currentUserToken")
        currentUser = User(id: UUID(uuidString: id)!, nickName: nickName, token: token)
        UserDefaults.standard.set(password, forKey: "currentUserPassword")
    }
    
    func getCurrentUserPassword() -> String? {
        return UserDefaults.standard.string(forKey: "currentUserPassword")
    }

    func clearCurrentUser() {
            UserDefaults.standard.removeObject(forKey: "currentUserId")
            UserDefaults.standard.removeObject(forKey: "currentUserNickName")
            UserDefaults.standard.removeObject(forKey: "currentUserToken")
            currentUser = nil
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
