import Combine
import SwiftUI

class AllGameRoomsViewModel: ObservableObject {
    @Published var gameRooms: [GameRoom]? = nil
    @Published var user: User = AuthService.shared.currentUser
    @Published var currentGameRoom: GameRoom? = nil

    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var showPasswordAlert: Bool = false
    @Published var showGameRoom: Bool = false

    func onAppear() {
        Task {
            do {
                let fetchedGameRooms = try await NetworkService.shared.getAllGameRooms()
                DispatchQueue.main.async {
                    self.gameRooms = fetchedGameRooms
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert.toggle()
                    self.errorMessage = "Произошла ошибка при получении комнат"
                }
            }
        }
    }

    func onTapGesture(selectedGameRoom: GameRoom) {
        if shouldShowPasswordAlert(selectedGameRoom: selectedGameRoom) {
            showPasswordAlert.toggle()
        } else {
            addUserIntoRoom(selectedGameRoom: selectedGameRoom)
        }
    }

    func enterPassword(enteredRoomCode: String, tappedRoom: GameRoom) {
        if checkRoomCode(enteredRoomCode: enteredRoomCode, correctRoomCode: tappedRoom.roomCode!) {
            addUserIntoRoom(selectedGameRoom: tappedRoom)
        } else {
            DispatchQueue.main.async {
                self.showErrorAlert.toggle()
                self.errorMessage = "Неверный пароль"
            }
        }
    }

    private func shouldShowPasswordAlert(selectedGameRoom: GameRoom) -> Bool {
        if let code = selectedGameRoom.roomCode, !code.isEmpty, user.nickName != selectedGameRoom.adminNickname {
            return true
        }
        return false
    }

    private func checkRoomCode(enteredRoomCode: String, correctRoomCode: String) -> Bool {
        return enteredRoomCode == correctRoomCode
    }

    private func addUserIntoRoom(selectedGameRoom: GameRoom) {
        Task {
            do {
                try await NetworkService.shared.addGamerIntoRoom(gamerId: user.id, roomId: selectedGameRoom.id)
                DispatchQueue.main.async {
                    self.showGameRoom.toggle()
                    self.currentGameRoom = selectedGameRoom
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert.toggle()
                    self.errorMessage = "Произошла ошибка при добавлении пользователя в комнату"
                }
            }
        }
    }
}
