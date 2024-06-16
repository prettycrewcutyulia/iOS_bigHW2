//
//  SdminSettingsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 16.06.2024.
//

import SwiftUI

struct AdminSettingsView: View {
    @State var allGamersIntoRoom: [UUID] = [UUID]()
    var roomId: UUID

    var body: some View {
        NavigationStack {
            List {
                ForEach(allGamersIntoRoom, id:\.uuidString) { gamer in
                    Text(gamer.uuidString)
//                    .onTapGesture {
//                        onTapGesture(selectedGameRoom: gameRoom)
//                        tappedGameRoom = gameRoom
//                    }
                }
            }
        }
        .onAppear {
            onAppear()
        }
    }
    
    func onAppear() {
            Task {
                do {
                    if let fetchedGameRooms = try await NetworkService.shared.getAllGamersIntoRoom(roomId: roomId) {
                        self.allGamersIntoRoom = fetchedGameRooms
                    }
                }
                catch {
//                    showErrorAlert.toggle()
//                    errorMessage = "Произошла ошибка при получении комнат"
                }
            }
        }
    
}

//#Preview {
//    AdminSettingsView()
//}
