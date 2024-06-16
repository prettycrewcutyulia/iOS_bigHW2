//
//  SdminSettingsView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 16.06.2024.
//

import SwiftUI

struct AdminSettingsView: View {
    @StateObject var viewModel: AdminSettingsViewModel
     var user = UserDefaultsService.shared.currentUser

    var roomId: UUID

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.allGamersIntoRoom, id:\.id) { gamer in
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
                                    viewModel.deleteGamerFromRoom(gamerId: gamer.id, roomId: roomId)
                                } label: {
                                    Label("Delete from room", systemImage: "xmark.seal")
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear(roomId: roomId)
        }
        .alert(isPresented: $viewModel.showErrorAlert, content: {
            return Alert(title: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok")))
        })
    }
}
