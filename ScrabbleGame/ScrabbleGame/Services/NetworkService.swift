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
    
    private let authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiI3ODFDMzU2OS1BOEU3LTQ0M0YtQTgzOC0yOTE0MTE3RjlCNzMiLCJleHAiOjE3MTg0ODk3NzQuODA2NTMyOX0.lruRHXrGdEGBzRdFkGVFkwSJ_TH2sZeSi5MSGWLztKs"
    
    // MARK: Создание игровой комнаты.
    func createGameRoom(adminNickname: String, roomCode: String?) async throws -> GameRoom {
        let dto = GameRoomDTO(adminNickname: adminNickname, roomCode: roomCode, gameStatus: GameStatus.NotStarted.rawValue, currentNumberOfChips: 40)
        
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)") else {
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
    
    // MARK: Смена статуса игры.
    func changeGameStatus(gameStatus: GameStatus, roomId: UUID) async throws -> GameRoom {
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
        
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)/\(roomId)/\(command)") else {
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
    
    // MARK: Выход из комнаты
    func leaveGameRoom(userId: UUID, roomId: UUID) async throws -> Bool {
        guard let url = URL(string: "\(localhost)\(APIMethod.leaveRoom.rawValue)/\(userId)/withRoom/\(roomId)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        do {
            let deleteGamerResponce = try await URLSession.shared.data(for: request)
            
            let deleteGamerData = deleteGamerResponce.1 as! HTTPURLResponse
            
            if deleteGamerData.statusCode == 200 {
                return true // Успешно покинули комнату
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // MARK: Получение всех комнат.
    func getAllGameRooms() async throws -> [GameRoom] {
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        let gameRoomResponce = try await URLSession.shared.data(for: request)
        let gameRoomData = gameRoomResponce.0
        
        let decoder = JSONDecoder()
        
        let gameRooms = try decoder.decode([GameRoom].self, from: gameRoomData)
        return gameRooms
    }
    
    // MARK: Добавление игрока в комнату
    func addGamerIntoRoom(gamerId: UUID, roomId: UUID) async throws -> Void {
        let dto = GamerRoomPairDTO(gamerId: gamerId, roomId: roomId)

        guard let url = URL(string: "\(localhost)/gamersIntoRoom") else {
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
        
        try await URLSession.shared.data(for: request)
    }
    
    // TODO: Вписывайте сюда свои методы
        
}

struct GameRoomDTO: Codable {
    let adminNickname: String
    let roomCode: String?
    let gameStatus: String
    let currentNumberOfChips: Int
}

struct GamerRoomPairDTO: Codable {
    let gamerId: UUID
    let roomId: UUID
}

// TODO: Вписывайте сюда свои ендпоинты
enum APIMethod: String {
    case gameRooms = "/gameRooms"
    case leaveRoom = "/gamersIntoRoom/deleteGamer"
}

enum NetworkError: Error {
    case badURL
}

