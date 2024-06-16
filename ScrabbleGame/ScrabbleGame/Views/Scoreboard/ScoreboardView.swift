//
//  ScoreboardView.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 16.06.2024.
//

import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var viewModel: ScoreboardViewModel

    var body: some View {
        VStack(alignment: .center) {
                    Text("Scoreboard")
                        .font(.title)

                    List {
                        HStack {
                            Text("Name")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("Score")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        
                        // Динамически созданные строки для каждой модели из списка
                        ForEach(viewModel.scoreboardModels.indices, id: \.self) { index in
                            HStack {
                                Text(viewModel.scoreboardModels[index].player ?? "No name")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                
                                Spacer() // Также добавим Spacer здесь
                                
                                Text("\(viewModel.scoreboardModels[index].score)")
                                    .font(.caption)
                            }
                        }
                    }
            CustomButton(buttonText:  Binding<String>.constant("Done"), buttonColor: Binding<Color>.constant(.black), isDisabled: false) {
                viewModel.onButtonDoneTap()
            }
                }
                .listStyle(PlainListStyle())
                .padding()
                .onAppear {
                    viewModel.onAppear()
                }
    }
}
