//
//  Coordinate.swift
//  ScrabbleGame
//
//  Created by Ярослав Гамаюнов on 16.06.2024.
//

import Foundation

// Координата
struct Coordinate: Codable, Hashable,  CustomStringConvertible {
    let x: String;
    let y: Int;
    
    var description: String {
        return "Coordinate(X: \(x), Y: \(y))"
    }
}
