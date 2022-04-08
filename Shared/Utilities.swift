//
//  Utilities.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI
import UIKit

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
    @Published var grid: Array<Array<squareState>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]] {
        didSet { Validator.global.setGrid(self.grid) }
    }
    @Published var player: playerState = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    @Published var drawScore: Int = 0
    
    @Published var locked: Bool = false
    
    public let generator = UIImpactFeedbackGenerator(style: .heavy)
    public var start: Date = Date()
    
    public func haptic() {
        generator.impactOccurred()
    }
    
    private func resetScore() {
        self.crossScore = 0
        self.noughtScore = 0
    }
    
    private func resetGrid() {
        self.grid = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
        self.player = .cross

        start = Date()
    }
    
    public func reset(_ option: resetOption) {
        switch option {
        case .grid: self.resetGrid()
        case .score: self.resetScore()
        }
    }
    
    static let global = Tesseract()
    private init() {}
}
