//
//  Structures.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 26/11/2022.
//

import Foundation

enum CellState {
    case none
    case cross
    case nought
}

enum gridState {
    case crossVictory
    case noughtVictory
    case draw
    case ongoing
}

enum AIState {
    case noob
    case expert
}

enum resetOption {
    case grid
    case score
}
