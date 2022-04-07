//
//  Utilities.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

enum squareState {
    case none
    case cross
    case nought
}

enum playerState {
    case cross
    case nought
}

enum resetOption {
    case grid
    case score
}

class Tesseract: ObservableObject {
    @Published var grid: Array<Array<squareState>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    @Published var player: playerState = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    
    private func resetScore() {
        self.crossScore = 0
        self.noughtScore = 0
    }
    
    private func resetGrid() {
        self.grid = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    }
    
    public func reset(_ option: resetOption) {
        switch option {
        case .grid: self.resetGrid()
        case .score: self.resetScore()
        }
        
        print(self.grid)
    }
    
    
    static let global = Tesseract()
    
    private init() {}
}
