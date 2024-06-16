//
//  GameRoomView.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct GameRoomView: View {
    @ObservedObject var viewModel: GameRoomViewModel


    var body: some View {
        NavigationStack {
            // TODO: В зависимости от того админ или нет показывать тот или иной экран
            GameTopBar(gameRoom: $viewModel.gameRoom, leaveRoom: $viewModel.leaveRoom, user: $viewModel.user, movePlayerId: $viewModel.movePlayerId)
            Spacer()
            
            if viewModel.gameRoom.gameStatus.lowercased() == GameStatus.Running.rawValue.lowercased() {
                let viewModelChipsField = ChipsFieldViewModel(chips: Binding<[ChipsOnField]>.constant([]), disabled: Binding<Bool>.constant(false))
                ChipField(viewModel: viewModelChipsField)
                    .disabled(false)
            }
            
            // Кнопка старата/паузы игры доступна только админу
            if viewModel.user.nickName == viewModel.gameRoom.adminNickname {
                CustomButton(buttonText: $viewModel.buttonText, buttonColor:  $viewModel.buttonColor, isDisabled: false) {
                    viewModel.changeGameStatus(buttonText: viewModel.buttonText)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.getButtonValue()
        }
        .alert(isPresented: $viewModel.showErrorAlert, content: {
            return Alert(title: Text("Произошла ошибка при смене статуса игры"), dismissButton: .default(Text("Ok")))
        })
    }
}
