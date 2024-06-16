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
        var chips = UserDefaultsService.shared.getCards()
        
        var needCount = 7 - (chips?.count ?? 0)
        
        for _ in 0..<needCount {
            // На самом деле делаем запрос на сервак
            let chip = Chip(alpha: "", point: 0)
            chips?.append(chip)
        }
        
        UserDefaultsService.shared.saveCards(chips ?? [])
        chipsOnHand = chips ?? []
    }
}
