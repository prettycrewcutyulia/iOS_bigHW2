//
//  CustomButtons.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct NextButtonView: View {
    let isDisabled: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action, label: {
            Text("Next")
                .foregroundStyle(.white)
                .font(.custom("Marcellus-Regular", size: 20))
        })
        .frame(width: 352, height: 65)
        .background(Color.black)
        .opacity(isDisabled ? 0.6 : 1)

        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .disabled(isDisabled)
    }
}
