//
//  ChipOnHandViewModel.swift
//  ScrabbleGame
//
//  Created by Юлия Гудошникова on 17.06.2024.
//

import Foundation

class ChipOnHandViewModel: ObservableObject {
    @Published var chipsOnHand: [Chip] = []
    
    func onAppear() {
        var chips = UserDefaultsService.shared.getCards() ?? []
        
        let needCount = 7 - chips.count
        
        for _ in 0..<needCount {
            Task {
                do {
                    let user = UserDefaultsService.shared.getCurrentUser()
                    let chip = try await NetworkService.shared.getChipsByGameId(gamerId: user.id)
                    if let chip {
                        DispatchQueue.main.async {
                            chips.append(chip)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        
        UserDefaultsService.shared.saveCards(chips)
        chipsOnHand = chips
    }
}
