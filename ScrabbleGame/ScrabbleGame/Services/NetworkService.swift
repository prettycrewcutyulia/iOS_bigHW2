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
    
    // TODO: Внимание! Это пока заглушки! Когда будет готов модуль с авторизацией,
    // TODO: сюда нужно будет передавать api key и header для авторизации
    private let apiKey = "f4bab26c-e061-413b-8d19-37f182b49725"
    
    private let authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiI3ODFDMzU2OS1BOEU3LTQ0M0YtQTgzOC0yOTE0MTE3RjlCNzMiLCJleHAiOjE3MTg0NzA5MDkuMDU4ODM3fQ.Lo-71dFa0HXgNFRMjSYaTd3UGwoLTnCQqxjt3bbsjjI"
    
    // Создание игровой комнаты.
    func createGameRoom(adminNickname: String, roomCode: String?) async throws -> GameRoom {
        let dto = GameRoomDTO(adminNickname: adminNickname, roomCode: roomCode, gameStatus: "Not started", currentNumberOfChips: 40)
        
        guard let url = URL(string: "\(localhost)\(APIMethod.createGameRoom.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(dto)
        request.httpBody = data
        
        let gameRoomResponce = try await URLSession.shared.data(for: request)
        let gameRoomData = gameRoomResponce.0
        
        let decoder = JSONDecoder()
        
        let gameRoom = try decoder.decode(GameRoom.self, from: gameRoomData)
        return gameRoom
    }
    
    func changeGameStatus(gameStatus: GameStatus, roomId: String) async throws -> GameRoom {
        var command: String
        
        switch gameStatus {
        case .Running:
            command = "run"
        case .Pause:
            command = "pause"
        case .End:
            command = "end"
        case .NotStarted:
            command = "stop"
        }
        
        guard let url = URL(string: "\(localhost)\(APIMethod.createGameRoom.rawValue)/\(roomId)/\(command)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        
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
    let roomCode: String?
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

