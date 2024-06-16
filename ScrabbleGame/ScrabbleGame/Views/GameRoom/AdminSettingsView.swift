//
//  SdminSettingsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 16.06.2024.
//

import SwiftUI

struct AdminSettingsView: View {
    @State var allGamersIntoRoom: [User] = [User]()
    @State var showErrorAlert: Bool = false
    @State var errorMessage: String = ""
     var user = UserDefaultsService.shared.currentUser

    var roomId: UUID

    var body: some View {
        NavigationStack {
            List {
                ForEach(allGamersIntoRoom, id:\.id) { gamer in
                    if gamer.id == user.id {
                        HStack {
                            Text("\(user.nickName)")
                                .bold()
                            Text(" (you)")
                        }
                        
                    } else {
                        Text(gamer.nickName)
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteGamerFromRoom(gamerId: gamer.id, roomId: roomId)
                                } label: {
                                    Label("Delete from room", systemImage: "xmark.seal")
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            onAppear()
        }
        .alert(isPresented: $showErrorAlert, content: {
            return Alert(title: Text(errorMessage), dismissButton: .default(Text("Ok")))
        })
    }
    
    func onAppear() {
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
                        errorMessage = failure.localizedDescription
                        showErrorAlert.toggle()
                    }
                }

            } catch {
                errorMessage = "Произошла ошибка при удалении игрока"
                showErrorAlert.toggle()
            }
        }

    }
}

//#Preview {
//    AdminSettingsView()
//}
