//
//  NetworkService.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService();
    
    private init() {}
    
    private let localhost = "http://127.0.0.1:8080"
    
    // Создание игровой комнаты.
    func createGameRoom(adminNickname: String, roomCode: String) async throws -> GameRoom {
        let dto = GameRoomDTO(adminNickname: adminNickname, roomCode: roomCode, gameStatus: "Not started", currentNumberOfChips: 40)
        
        guard let url = URL(string: "\(localhost)\(APIMethod.createGameRoom.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // TODO: Внимание! Это пока заглушки! Когда будет готов модуль с авторизацией, из него нужно взять:
        // api key и JWT токен соответственно.
        request.addValue("5b570c08-e48a-49de-bee0-e138b8170176", forHTTPHeaderField: "ApiKey")
        request.addValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTgyMTE0OTIuODA1MDU2LCJ1c2VySUQiOiI3ODFDMzU2OS1BOEU3LTQ0M0YtQTgzOC0yOTE0MTE3RjlCNzMifQ.G5IW4FQ1iIL5wGEqm2NwYztsGPzNSzjA-5Uasgm5FwI", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let gameRoomResponce = try await URLSession.shared.data(for: request)
        let gameRoomData = gameRoomResponce.0
        
        let decoder = JSONDecoder()
        
        let gameRoom = try decoder.decode(GameRoom.self, from: gameRoomData)
        return gameRoom
    }
    
    // TODO: Вписывайте сюда свои методы
        
}

struct GameRoomDTO: Codable {
    let adminNickname: String
    let roomCode: String
    let gameStatus: String
    let currentNumberOfChips: Int
}

// TODO: Вписывайте сюда свои ендпоинты
enum APIMethod: String {
    case createGameRoom = "/gameRooms"
}

enum NetworkError: Error {
    case badURL
}

