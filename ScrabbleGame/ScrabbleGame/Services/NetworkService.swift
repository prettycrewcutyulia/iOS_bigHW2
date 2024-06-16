//
//  NetworkService.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService();

    let getRoomStatusEvent = PassthroughSubject<String, Never>()
    let getMoveEvent = PassthroughSubject<UUID, Never>()
    let getCountChipsInTileEvent = PassthroughSubject<Int, Never>()
    let getChipsOnFieldEvent = PassthroughSubject<[ChipsOnField], Never>()

    private init() {}
    
    private let localhost = "http://127.0.0.1:8080"
    
    // TODO: Внимание! Это пока заглушки! Когда будет готов модуль с авторизацией,
    // TODO: сюда нужно будет передавать api key и header для авторизации
    private let apiKey = "daabf827-b319-4e69-8537-f08f27a1858c"
    
    private let authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiJBQjZCRDdGNS1CMzA5LTQwNDgtQTY3OC05MEU2RDZGRDAyQTEiLCJleHAiOjE3MTg2NTUxNjEuMjU0Nzg2fQ.NGFrarcnVfeKUyaJ2R6xJV5SyontP9H1gijjzJZltOU"

    private var timerGameRoomView: Timer?
    private var statusTimer: Timer?
    
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
    func leaveGameRoom(userId: UUID, roomId: UUID, completion: @escaping (Result<Void, Error>) -> Void) async throws  {
        guard let url = URL(string: "\(localhost)\(APIMethod.leaveRoom.rawValue)/\(userId)/withRoom/\(roomId)") else {
            throw NetworkError.badURL
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        // Создаем задачу для выполнения запроса
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                // Обработка ошибки, если запрос не удался
                print("Ошибка: \(error)")
                return
            }
            self.getServerResponse(response: response, data: data) { result in
                switch result {
                case .success(_): break
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        // Запускаем задачу
        task.resume()
        completion(.success(()))
    }
    
    // MARK: Получение всех комнат.
    func getAllGameRooms() async throws -> [GameRoom]? {
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let gameRoomResponce = try await URLSession.shared.data(for: request)
            let gameRoomData = gameRoomResponce.0
            
            let decoder = JSONDecoder()
            
            let gameRooms = try decoder.decode([GameRoom].self, from: gameRoomData)
            return gameRooms
        }
        catch {
            return nil
        }
    }
    
    // MARK: Получение статуса комнаты по id.
    func getGameRoomStatusById(roomId: UUID) async throws -> String? {
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)/\(roomId)") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let gameRoomResponce = try await URLSession.shared.data(for: request)
            let gameRoomData = gameRoomResponce.0
            
            let decoder = JSONDecoder()
            
            let gameRooms = try decoder.decode(GameRoom.self, from: gameRoomData)
            return gameRooms.gameStatus
        }
        catch {
            return nil
        }
    }
    
    // MARK: Получение всех игроков по комнате.
    func getAllGamersIntoRoom(roomId: UUID) async throws -> [User]? {
        guard let url = URL(string: "\(localhost)\(APIMethod.allGamers.rawValue)/\(roomId)/gamersIds") else {
            throw NetworkError.badURL
        }
        
        var users = [User]()
        print(url)
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let gamersResponce = try await URLSession.shared.data(for: request)
            let gamersData = gamersResponce.0
            
            let decoder = JSONDecoder()
            
            let gamersIds = try decoder.decode([UUID].self, from: gamersData)
            
            for id in gamersIds {
                if let user = try await getUserById(userId: id) {
                    users.append(user)
                }
            }
            return users
        }
        catch {
            return nil
        }
    }
    
    // MARK: Получение всех ходов в игре
    func getMovesByGameId(roomId: UUID) async throws -> [ChipsOnField]? {
        return nil
    }
    
    // MARK: Чей же ход?
    func whoseMoves(roomId: UUID, moveCount: Int) async throws -> UUID {
        let users = try await getAllGamersIntoRoom(roomId: roomId)
        
        let who = users?[moveCount % (users?.count ?? 1)]
        
        return who?.id ?? UUID()
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
    
    // MARK: Удаление комнаты по id.
    func deleteRoomById(roomId: UUID, completion: @escaping (Result<Void, Error>) -> Void) async throws {
        guard let url = URL(string: "\(localhost)\(APIMethod.deleteRooms.rawValue)/\(roomId)") else {
            throw NetworkError.badURL
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        // Создаем задачу для выполнения запроса
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                // Обработка ошибки, если запрос не удался
                print("Ошибка: \(error)")
                return
            }
            self.getServerResponse(response: response, data: data) { result in
                switch result {
                case .success(_): break
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        // Запускаем задачу
        task.resume()
        completion(.success(()))
    }
    
    func fetchLeaderboard(forRoomId roomId: UUID) async -> [ScoreboardModel]? {
        guard let url = URL(string: "\(localhost)/gameRooms/\(roomId)/getLeaderBoard") else {
            return nil
        }
        print(url)
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let scoreResponce = try await URLSession.shared.data(for: request)
            let gamersData = scoreResponce.0
            
            let decoder = JSONDecoder()
            
            let gamers = try decoder.decode([ScoreboardModel].self, from: gamersData)
            return gamers
        }
        catch {
            return nil
        }
    }
    
    // Метод для старта таймера
    func startGameRoomViewTimer() {
           // Настройка таймера для вызова метода sendRequest каждые 30 секунд
           timerGameRoomView = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(sendRequest), userInfo: nil, repeats: true)
           
           // Немедленный первый запрос
           sendRequest()
    }
       
   // Метод для остановки таймера
   func stopGameRoomViewTimer() {
       timerGameRoomView?.invalidate()
       timerGameRoomView = nil
       print("Сработало(таймер выключился)")
   }
    
    @objc private func sendRequest() {
        Task {
            do {
                let roomId = UUID(uuidString: UserDefaultsService.shared.getCurrentGameId() ?? "") ?? UUID()
                let count = try await getCurrentChipsInGameRoomById(roomId: roomId)
                self.getCountChipsInTileEvent.send(count ?? 0)
            } catch {
                print(error)
            }
        }
        Task {
            do {
                let roomId = UUID(uuidString: UserDefaultsService.shared.getCurrentGameId() ?? "") ?? UUID()
                let chips = try await getMovesByGameId(roomId: roomId)
                self.getChipsOnFieldEvent.send(chips ?? [])
                
                let who = try await whoseMoves(roomId: roomId, moveCount: ((chips?.count ?? 0) + 1))
                self.getMoveEvent.send(who)
            }
        }
    }
    
    // Таймер на обновление статуса игры
    func startGameRoomStatusTimer(roomId: UUID) {
        statusTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(sendUpdateRoomStatusRequest), userInfo: nil, repeats: true)
        
         sendUpdateRoomStatusRequest()
    }
    
    // Метод для остановки таймера
    func stopGameRoomStatusTimer() {
        statusTimer?.invalidate()
        statusTimer = nil
    }
    
    @objc private func sendUpdateRoomStatusRequest()  {
        Task {
            do {
                var gameStatus = try await getGameRoomStatusById(roomId: UUID(uuidString: UserDefaultsService.shared.getCurrentGameId() ?? "") ?? UUID())
                getRoomStatusEvent.send(gameStatus ?? "Not Started")
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Private functions
    
    // MARK: Обработка ответов сервера
    private func getServerResponse(response: URLResponse?, data: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        if let httpResponse = response as? HTTPURLResponse {
            // Получаем статус код ответа
            let statusCode = httpResponse.statusCode

            if statusCode >= 200 && statusCode <= 300 {
                if let data = data {
                    completion(.success((data)))
                }
            } else {
                do {
                    if let errMessage = try JSONSerialization.jsonObject(with: data ?? Data()) as? [String: Any] {
                        if let reason = errMessage["reason"] as? String {
                            completion(.failure(NSError(domain: "ServerError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: reason])))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: Получение количества фишек в комнате по id.
    func getCurrentChipsInGameRoomById(roomId: UUID) async throws -> Int? {
        guard let url = URL(string: "\(localhost)\(APIMethod.gameRooms.rawValue)/\(roomId)/getChipsNumber") else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let chipsCount = try JSONDecoder().decode(Int.self, from: data)
            return chipsCount
        }
        catch {
            return nil
        }
    }
    
    // MARK: Получение пользователя по id.
    private func getUserById(userId: UUID) async throws -> User? {
        guard let url = URL(string: "\(localhost)\(APIMethod.getUserById.rawValue)/\(userId)") else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        do {
            let gamersResponce = try await URLSession.shared.data(for: request)
            let gamersData = gamersResponce.0
            
            let decoder = JSONDecoder()
            
            let gamers = try decoder.decode(User.self, from: gamersData)
            return gamers
        }
        catch {
            return nil
        }
    }
    
    // MARK: Получение фишек по id игрока.
    func getChipsByGameId(gamerId: UUID) async throws -> Chip? {
        guard let url = URL(string: "\(localhost)\(APIMethod.getChipByGamerId.rawValue)/\(gamerId)/getChipsNumber") else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        request.addValue(apiKey, forHTTPHeaderField: "ApiKey")
        request.addValue(authorization, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let chips = try JSONDecoder().decode([Chip].self, from: data)
            return chips.first

        } catch {
            throw error // Handle and rethrow errors more effectively.
        }
    }

        
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
    case allGamers = "/gamersIntoRoom/roomId"
    case deleteRooms = "/gamersIntoRoom/deleteRoomWithId"
    case getUserById = "/auth/getUserById"
    case getChipByGamerId = "/gamersIntoRoom/gamerId"
}

enum NetworkError: Error {
    case badURL
}

