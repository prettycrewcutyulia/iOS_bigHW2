//
//  WinsView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

struct WinsView: View {

    @ObservedObject var viewModel: WinsViewModel = WinsViewModel()
    
    var body: some View {
        VStack {
            Text("Game over!")
                .font(.title)
                .padding()

            Text(winnerMessage())
                .font(.headline)
                .onAppear {
                    viewModel.onAppear()
                }

            ScoreboardViewList(scoreboardModels: viewModel.scoreboardModels)

            NavigationLink(destination: viewModel.nextScreen, isActive: $viewModel.navigateToNextScreen) {
                CustomButton(buttonText:  Binding<String>.constant("Done"), buttonColor: Binding<Color>.constant(.black), isDisabled: false) {
                    viewModel.onButtonDoneTap()
                }
            }
        }
    }
    
    // Функция для определения победителя
    func winnerMessage() -> String {
        if (viewModel.scoreboardModels.count < 2) {
            return "Win \(viewModel.scoreboardModels[0])!"
        }
        if viewModel.scoreboardModels[0] > viewModel.scoreboardModels[1] {
            return "Win \(viewModel.scoreboardModels[0])!"
        } else if viewModel.scoreboardModels[1] > viewModel.scoreboardModels[0]  {
            return "Win \(viewModel.scoreboardModels[1])!"
        } else {
            return "Draw!"
        }
    }
}
