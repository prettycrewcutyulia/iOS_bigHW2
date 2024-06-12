//
//  CustomViews.swift
//  ScrabbleGame
//
//  Created by Irina Pechik on 12.06.2024.
//

import SwiftUI

struct CustomTextView: View {
    @Binding var variable: String
    var placeholderName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholderName)
            
            TextField("", text: Binding(
                get: { self.variable },
                set: { self.variable = $0 }
            ))
                .frame(height: 25) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}

