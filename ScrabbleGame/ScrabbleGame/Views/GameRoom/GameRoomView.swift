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
            // В зависимости от того админ или нет показывается тот или иной экран
            GameTopBar(gameRoom: $viewModel.gameRoom, leaveRoom: $viewModel.leaveRoom, movePlayerId: $viewModel.movePlayerId)
            LetterInTileCounterView(count: $viewModel.countChipsInTile)
            Spacer()
            
            if viewModel.gameRoom.gameStatus.lowercased() == GameStatus.Running.rawValue.lowercased() {
                let viewModelChipsField = ChipsFieldViewModel(chips: $viewModel.chipsOnField, disabled: $viewModel.disabledMove)
                ChipField(viewModel: viewModelChipsField)
                    .disabled(viewModel.disabledMove)
            }
            
            // Кнопка старата/паузы игры доступна только админу
            if viewModel.user.nickName == viewModel.gameRoom.adminNickname {
                CustomButton(buttonText: $viewModel.buttonText, buttonColor:  $viewModel.buttonColor, isDisabled: false) {
                    viewModel.changeGameStatus(buttonText: viewModel.buttonText)
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showWinView) {
            WinsView(viewModel: WinsViewModel())
        }
        .onAppear {
            viewModel.getButtonValue()
        }
        .alert(isPresented: $viewModel.showErrorAlert, content: {
            return Alert(title: Text("Произошла ошибка при смене статуса игры"), dismissButton: .default(Text("Ok")))
        })
    }
}
